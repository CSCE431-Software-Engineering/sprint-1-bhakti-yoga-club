require 'rails_helper'

RSpec.describe MembersController, type: :controller do
  include Devise::Test::ControllerHelpers # Include Devise test helpers

  let!(:existing_member) { Member.find_by(email: "admin@example.com") || Member.create(full_name: "Admin User", email: "admin@example.com", date_joined: Date.today) }
  let(:member) { existing_member }

  let!(:existing_member2) { Member.find_by(email: "test2@example.com") || Member.create(email: "test2@example.com")}
  let(:member2) { existing_member2 }

  before do
    @request.env['devise.mapping'] = Devise.mappings[:member]
    member.update(is_admin: true)
    session[:admin_view] = true
    sign_in member
  end

  describe "GET #index" do
    it "returns a successful response" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    let(:existing_member) { Member.find_by(email: "test@example.com") || Member.create(email: "test@example.com") }


    it "returns a successful response" do
      get :show, params: { id: member.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #new" do
    it "returns a successful response" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "creates a new member" do
        valid_attributes = { email: "test_create@example.com" } # Define valid attributes manually
        expect {
          post :create, params: { member: valid_attributes }
        }.to change(Member, :count).by(1)
      end
    end

    context "with invalid attributes" do
      it "does not create a new member" do
        expect {
          post :create, params: { member: { email: nil } }
        }.not_to change(Member, :count)
      end
    end
  end

  describe "GET #edit" do
    it "returns a successful response" do
      get :edit, params: { id: existing_member.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe "PUT #update" do
    let(:existing_member) { Member.find_by(email: "test@example.com") || Member.create(email: "test@example.com") }

    context "with valid attributes" do
      it "updates the member" do
        put :update, params: { id: member.id, member: { email: "new_email@example.com" } }
        member.reload
        expect(member.email).to eq("new_email@example.com")
      end
    end

    context "with invalid attributes" do
      it "does not update the member" do
        put :update, params: { id: member.id, member: { email: nil } }
        member.reload
        expect(member.email).not_to be_nil
      end
    end
  end

  describe "GET #delete" do
    it "assigns the requested member to @member" do
      get :delete, params: { id: existing_member.id }
      expect(assigns(:member)).to eq(member_test5)
    end

    it "renders the delete template" do
      member_test6 = Member.create(email: "member_test6@example.com")
      get :delete, params: { id: member_test6.id }
      expect(response).to render_template(:delete)
    end
  end

  describe "DELETE #destroy" do
    context "as an admin" do
      it "destroys another member" do
        
        member_test2 = Member.create(email: "member_test2@example.com")
        expect {
          delete :destroy, params: { id: member_test2.id }
        }.to change(Member, :count).by(-1)
        expect(flash[:notice]).to eq "Member deleted"
        expect(response).to redirect_to(root_path)
      end

      it "does not delete themselves" do
        expect {
          delete :destroy, params: { id: member.id }
        }.not_to change(Member, :count)
        expect(flash[:notice]).to eq "You cannot delete yourself."
        expect(response).to redirect_to(root_path)
      end

      it "signs out if requested" do
        expect {
          delete :destroy, params: { id: "sign_out" }
        }.not_to change(Member, :count)
        expect(flash[:notice]).to eq "You have been signed out"
        expect(response).to redirect_to(root_path)
      end
    end

    context "as a regular user" do
      before do
        sign_out member
        sign_in member2
      end

      it "signs out" do
        expect {
          delete :destroy, params: { id: "sign_out" }
        }.not_to change(Member, :count)
        expect(flash[:notice]).to eq "You have been signed out"
        expect(response).to redirect_to(root_path)
      end
    end

    context "when not signed in" do
      it "redirects to root path" do
        sign_out member
        delete :destroy, params: { id: member.id }
        expect(flash[:alert]).to eq "You are not signed in."
        expect(response).to redirect_to(root_path)
      end
    end
  end
end