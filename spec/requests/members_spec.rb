require 'rails_helper'

RSpec.describe "Members", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get members_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    member = Member.create(email: "test@example.com")

    it "returns http success" do
      get member_path(member)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get new_member_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get create_member_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      member = Member.create(email: "test@example.com")
      get edit_member_path(member)
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /update" do
    it "returns http success" do
      member = Member.create(email: "test@example.com")
      patch update_member_path(member), params: { member: {
        email: "test@exampletest.com",
        title: "Title Test",
        is_active_paid_member: true,
        is_admin: true
      }}
      expect(response).to have_http_status(:redirect)

      follow_redirect!

      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /delete" do
    it "returns http success" do
      member = Member.create(email: "test@example.com")
      get confirm_delete_member_path(member)
      expect(response).to have_http_status(:success)
    end
  end

  describe "DELETE /destroy" do
    it "returns http success" do
      member = Member.create(email: "test@example.com")
      delete delete_member_path(member)
      expect(response).to have_http_status(:redirect)
      follow_redirect!
      expect(response).to have_http_status(:success)
    end
  end

end
