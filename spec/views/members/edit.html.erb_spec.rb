require 'rails_helper'

RSpec.describe "members/edit.html.erb", type: :view do
  include Devise::Test::ControllerHelpers # Include Devise test helpers

  context "normal member edit" do
    let(:member) { Member.create(full_name: 'John Doe', email: 'john@example.com', date_joined: Date.today) }

    before do
      allow(view).to receive(:current_member).and_return(member)
      assign(:member, member)
      render
    end
  
    it "displays the heading" do
      expect(rendered).to have_selector('h2', text: 'Edit Member Information')
    end
  
    it "displays member information" do
      expect(rendered).to have_text("Email:")
      expect(rendered).to have_text("Name:")
      expect(rendered).to have_unchecked_field("member_is_on_mailing_list")
    end

    it "does not display hidden fields" do
      expect(rendered).not_to have_field("member_title", with: member.title)
      expect(rendered).not_to have_unchecked_field("member_is_active_paid_member")
      expect(rendered).not_to have_unchecked_field("member_is_admin")
    end
  
    it "displays the form for updating member information" do
      expect(rendered).to have_selector("form[action='#{update_member_path(member)}'][method='post']") do |form|
        expect(form).not_to have_field('member_title')
        expect(form).not_to have_field('member_is_active_paid_member')
        expect(form).not_to have_field('member_is_admin')
        expect(form).to have_field('member_is_on_mailing_list')
        expect(form).to have_button('Update Information')
      end
    end
  
    it "displays a link back to members index" do
      expect(rendered).to have_link("Back to Members", href: members_path)
    end
  end

  context "admin member edit (admin mode)" do
    let(:admin_member) { Member.create(full_name: 'John Doe', email: 'john@example.com', date_joined: Date.today, is_admin: true) }

    before do
      allow(view).to receive(:current_member).and_return(admin_member)
      assign(:member, admin_member)
      admin_member.update(is_admin: true)
      session[:admin_view] = true
      render
    end
  
    it "displays the heading" do
      expect(rendered).to have_selector('h2', text: 'Edit Member Information')
    end

    it "displays correct info" do
      expect(rendered).to have_text(admin_member.email)
    end
  
    it "displays member information" do
      expect(rendered).to have_text("Email:")
      expect(rendered).to have_text("Name:")
      expect(rendered).to have_text("Title:") # Corrected expectation
      expect(rendered).to have_unchecked_field("member_is_active_paid_member")
      expect(rendered).to have_checked_field("member_is_admin")
      expect(rendered).to have_unchecked_field("member_is_on_mailing_list")
    end
  
    it "displays the form for updating member information" do
      expect(rendered).to have_selector("form[action='#{update_member_path(admin_member)}'][method='post']") do |form|
        expect(form).to have_field('member_title')
        expect(form).to have_field('member_is_active_paid_member')
        expect(form).to have_field('member_is_admin')
        expect(form).to have_field('member_is_on_mailing_list')
        expect(form).to have_button('Update Information')
      end
    end
  
    it "displays a link back to members index" do
      expect(rendered).to have_link("Back to Members", href: members_path)
    end
  end

  context "admin member edit (member mode)" do

    let(:admin_member) { Member.create(full_name: 'John Doe', email: 'john@example.com', date_joined: Date.today, is_admin: true) }

    before do
      allow(view).to receive(:current_member).and_return(admin_member)
      assign(:member, admin_member)
      admin_member.update(is_admin: true)
      session[:admin_view] = false
      render
    end
  
    it "displays the heading" do
      expect(rendered).to have_selector('h2', text: 'Edit Member Information')
    end
  
    it "displays member information" do
      expect(rendered).to have_text("Email:")
      expect(rendered).to have_text("Name:")
      expect(rendered).to have_unchecked_field("member_is_on_mailing_list")
    end

    it "does not display hidden fields" do
      expect(rendered).not_to have_field("member_title")
      expect(rendered).not_to have_unchecked_field("member_is_active_paid_member")
      expect(rendered).not_to have_unchecked_field("member_is_admin")
    end
  
    it "displays the form for updating member information" do
      expect(rendered).to have_selector("form[action='#{update_member_path(admin_member)}'][method='post']") do |form|
        expect(form).not_to have_field('member_title')
        expect(form).not_to have_field('member_is_active_paid_member')
        expect(form).not_to have_field('member_is_admin')
        expect(form).to have_field('member_is_on_mailing_list')
        expect(form).to have_button('Update Information')
      end
    end
  
    it "displays a link back to members index" do
      expect(rendered).to have_link("Back to Members", href: members_path)
    end

  end
end
