require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe "#require_admin" do
    controller do
      before_action :require_admin

      def index
        render plain: "Hello, admin!"
      end
    end

    context "when member is an admin" do
      let(:admin_member) { create(:member, is_admin: true) }

      before do
        sign_in admin_member
      end

      it "allows access to the action" do
        get :index
        expect(response).to have_http_status(:success)
      end
    end

    context "when member is not an admin" do
      let(:regular_member) { create(:member, is_admin: false) }

      before do
        sign_in regular_member
      end

      it "redirects to root with an alert" do
        get :index
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("You are not authorized to access this page.")
      end
    end

    context "when no member is signed in" do
      it "redirects to root with an alert" do
        get :index
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("Please sign in to access this page.")
      end
    end
  end

  describe "#authenticate_member!" do
    controller do
      before_action :authenticate_member!

      def index
        render plain: "Hello, member!"
      end
    end

    context "when member is signed in" do
      let(:signed_in_member) { create(:member) }

      before do
        sign_in signed_in_member
      end

      it "allows access to the action" do
        get :index
        expect(response).to have_http_status(:success)
      end
    end

    context "when no member is signed in" do
      it "redirects to root with an alert" do
        get :index
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("Please sign in to access this page.")
      end
    end
  end

  describe "#set_admin_view" do
    controller do
      before_action :set_admin_view

      def index
        render plain: session[:admin_view].to_s
      end
    end

    context "when admin_view session is not set" do
      context "when current_member is an admin" do
        let(:admin_member) { create(:member, is_admin: true) }

        before do
          sign_in admin_member
          get :index
        end

        it "sets admin_view to true" do
          expect(session[:admin_view]).to be true
        end

        it "renders the index action with admin_view as 'true'" do
          expect(response.body).to eq("true")
        end
      end

      context "when current_member is not an admin" do
        let(:regular_member) { create(:member, is_admin: false) }

        before do
          sign_in regular_member
          get :index
        end

        it "sets admin_view to false" do
          expect(session[:admin_view]).to be false
        end

        it "renders the index action with admin_view as 'false'" do
          expect(response.body).to eq("false")
        end
      end

      context "when no member is signed in" do
        before { get :index }

        it "sets admin_view to false" do
          expect(session[:admin_view]).to be false
        end

        it "renders the index action with admin_view as 'false'" do
          expect(response.body).to eq("false")
        end
      end
    end

    context "when admin_view session is already set" do
      before do
        session[:admin_view] = true
        get :index
      end

      it "does not change admin_view session" do
        expect(session[:admin_view]).to be true
      end

      it "renders the index action with admin_view as 'true'" do
        expect(response.body).to eq("true")
      end
    end
  end

  describe "#toggle_admin_view" do
    controller do
      before_action :toggle_admin_view

      def index
        render plain: session[:admin_view].to_s
      end
    end

    context "when admin_view session is set to true" do
      before do
        session[:admin_view] = true
        get :index
      end

      it "toggles admin_view to false" do
        expect(session[:admin_view]).to be false
      end

      it "renders the index action with admin_view as 'false'" do
        expect(response.body).to eq("false")
      end
    end

    context "when admin_view session is set to false" do
      before do
        session[:admin_view] = false
        get :index
      end

      it "toggles admin_view to true" do
        expect(session[:admin_view]).to be true
      end

      it "renders the index action with admin_view as 'true'" do
        expect(response.body).to eq("true")
      end
    end
  end
end
