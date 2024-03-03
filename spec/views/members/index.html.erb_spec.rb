require 'rails_helper'

RSpec.describe "members/index.html.erb", type: :view do
  context "when a normal member is signed in" do
    let(:normal_member) { Member.create(full_name: 'John Doe', email: 'john@example.com', date_joined: Date.today, is_admin: false) }

    before do
      allow(view).to receive(:current_member).and_return(normal_member)
      assign(:members, [normal_member]) # Assuming you're assigning the current member to @members
    end

    it "displays the member's name and join date" do
      render
      expect(rendered).to have_selector("th.name", text: "Name")
      expect(rendered).to have_selector("th.join-date", text: "Join Date")
      expect(rendered).to have_text(normal_member.full_name)
      expect(rendered).to have_text(normal_member.date_joined)
    end

    it "does not display the admin-specific table contents" do
      render
      expect(rendered).not_to have_selector("th.email", text: "Email")
      expect(rendered).not_to have_selector("th.left-date", text: "Date Left")
      expect(rendered).not_to have_selector("th.paid-status", text: "Paid Member Status")
      expect(rendered).not_to have_selector("th.admin-status", text: "Admin Status")
      expect(rendered).not_to have_selector("th.member-actions", text: "Member Actions")
      expect(rendered).not_to have_text("Show")
      expect(rendered).not_to have_text("Edit")
    end

    # Add more tests for other content or elements on the page
  end

  context "when an admin member is signed in" do
    let(:admin_member) { Member.create(full_name: "Admin User", email: "admin@example.com", date_joined: Date.today) }
    

    before do
      allow(view).to receive(:current_member).and_return(admin_member)
      assign(:members, [admin_member]) # Assuming you're assigning the current member to @members
      admin_member.update(is_admin: true)
      session[:admin_view] = true
    end

    it "displayes base contents" do
      render
      expect(rendered).to have_text("Members List")
      expect(rendered).to have_text("Back to Home")
    end

    it "displays the member's name and join date" do
      render
      expect(rendered).to have_selector("th.name", text: "Name")
      expect(rendered).to have_selector("th.join-date", text: "Join Date")
      expect(rendered).to have_text(admin_member.full_name)
      expect(rendered).to have_text(admin_member.date_joined)
    end

    it "displays admin-specific table headers" do
      render
      expect(rendered).to have_selector("th.email", text: "Email")
      expect(rendered).to have_selector("th.left-date", text: "Date Left")
      expect(rendered).to have_selector("th.paid-status", text: "Paid Member Status")
      expect(rendered).to have_selector("th.admin-status", text: "Admin Status")
      expect(rendered).to have_selector("th.member-actions", text: "Member Actions")
    end

    it "displays admin-specific member details" do
      render
      expect(rendered).to have_text(admin_member.email)
      expect(rendered).to have_text(admin_member.is_active_paid_member)
      expect(rendered).to have_text(admin_member.date_left)
      expect(rendered).to have_text(admin_member.is_admin)
      expect(rendered).to have_text("Show")
      expect(rendered).to have_text("Edit")
      # Add more expectations for other admin-specific actions
    end

    # Add more tests for other content or elements on the page
  end

  context "when an admin member is signed in and viewing member mode" do
    let(:admin_member) { Member.create(full_name: "Admin User", email: "admin@example.com", date_joined: Date.today) }
    

    before do
      allow(view).to receive(:current_member).and_return(admin_member)
      assign(:members, [admin_member]) # Assuming you're assigning the current member to @members
      admin_member.update(is_admin: true)
      session[:admin_view] = false
    end

    it "displays the member's name and join date" do
      render
      expect(rendered).to have_selector("th.name", text: "Name")
      expect(rendered).to have_selector("th.join-date", text: "Join Date")
      expect(rendered).to have_text(admin_member.full_name)
      expect(rendered).to have_text(admin_member.date_joined)
    end

    it "does not display the admin-specific table contents" do
      render
      expect(rendered).not_to have_selector("th.email", text: "Email")
      expect(rendered).not_to have_selector("th.left-date", text: "Date Left")
      expect(rendered).not_to have_selector("th.paid-status", text: "Paid Member Status")
      expect(rendered).not_to have_selector("th.admin-status", text: "Admin Status")
      expect(rendered).not_to have_selector("th.member-actions", text: "Member Actions")
      expect(rendered).not_to have_text("Show")
      expect(rendered).not_to have_text("Edit")
    end

    # Add more tests for other content or elements on the page
  end

end
