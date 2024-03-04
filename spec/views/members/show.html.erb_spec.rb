require 'rails_helper'

RSpec.describe "members/show.html.erb", type: :view do
  include Devise::Test::ControllerHelpers # Include Devise test helpers

  context "general info" do
    let(:normal_member) { Member.create(full_name: 'John Doe', email: 'john@example.com', date_joined: Date.today, is_admin: false) }

    before do
      allow(view).to receive(:current_member).and_return(normal_member)
      assign(:member, normal_member)
    end

    it "displays title" do
      render
      expect(rendered).to have_text("Member Information")
    end

  end
  
  context "when a normal member is signed in" do
    let(:normal_member) { Member.create(full_name: 'John Doe', email: 'john@example.com', date_joined: Date.today, is_admin: false) }

    before do
      allow(view).to receive(:current_member).and_return(normal_member)
      assign(:member, normal_member)
    end

    it "displays relevent categories" do
      render
      expect(rendered).to have_text("Full Name:")
      expect(rendered).to have_text("Email:")
      expect(rendered).to have_text("Date Joined:")
      expect(rendered).to have_text("Paid Status:")
    end

    it "displays that member's name, email, join date, and paid status" do
      render
      expect(rendered).to have_text(normal_member.full_name)
      expect(rendered).to have_text(normal_member.email)
      expect(rendered).to have_text(normal_member.date_joined)
      expect(rendered).to have_text(normal_member.is_active_paid_member)
    end

    it "does not display the admin-specific categories" do
      render
      expect(rendered).not_to have_text("Member Title:")
      expect(rendered).not_to have_text("Date Left:")
    end

    # Add more tests for other content or elements on the page
  end

  context "when and admin is looking at member view" do
    let(:admin_member) { Member.create(full_name: 'John Doe', email: 'john@example.com', date_joined: Date.today) }
    

    before do
      allow(view).to receive(:current_member).and_return(admin_member)
      assign(:member, admin_member)
      admin_member.update(is_admin: true)
      session[:admin_view] = false
    end

    it "displays relevent categories" do
      render
      expect(rendered).to have_text("Full Name:")
      expect(rendered).to have_text("Email:")
      expect(rendered).to have_text("Date Joined:")
      expect(rendered).to have_text("Paid Status:")
    end

    it "displays that member's name, email, join date, and paid status" do
      render
      expect(rendered).to have_text(admin_member.full_name)
      expect(rendered).to have_text(admin_member.email)
      expect(rendered).to have_text(admin_member.date_joined)
      expect(rendered).to have_text(admin_member.is_active_paid_member)
    end

    it "does not display the admin-specific categories" do
      render
      expect(rendered).not_to have_text("Member Title:")
      expect(rendered).not_to have_text("Date Left:")
    end

    # Add more tests for other content or elements on the page
  end

  context "when an admin is looking at member view" do
    let(:admin_member) { Member.create(full_name: 'John Doe', email: 'john@example.com', date_joined: Date.today) }
    

    before do
      allow(view).to receive(:current_member).and_return(admin_member)
      assign(:member, admin_member)
      admin_member.update(is_admin: true)
      session[:admin_view] = true
    end

    it "displays relevent categories" do
      render
      expect(rendered).to have_text("Full Name:")
      expect(rendered).to have_text("Email:")
      expect(rendered).to have_text("Date Joined:")
      expect(rendered).to have_text("Member Title:")
      expect(rendered).to have_text("Date Left:")
      expect(rendered).to have_text("Paid Status:")
    end

    it "displays that member's name, email, join date, and paid status" do
      render
      expect(rendered).to have_text(admin_member.full_name)
      expect(rendered).to have_text(admin_member.email)
      expect(rendered).to have_text(admin_member.date_joined)
      expect(rendered).to have_text(admin_member.title)
      expect(rendered).to have_text(admin_member.date_left)
      expect(rendered).to have_text(admin_member.is_active_paid_member)
    end

    # Add more tests for other content or elements on the page
  end
end
