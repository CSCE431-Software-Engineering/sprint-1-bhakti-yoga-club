require 'rails_helper'

RSpec.describe "concerns/new.html.erb", type: :view do
  let(:existing_member_email) { "test@example.com" }
  let(:existing_member) { Member.find_by(email: existing_member_email) }

  before(:each) do
    assign(:concern, Concern.new) # Assign a new instance of Concern to @concern
    allow(view).to receive(:current_member).and_return(existing_member)
  end

  it "renders the form" do
    render
    expect(rendered).to have_selector("form[action='#{member_concerns_path(existing_member)}'][method='post']") do |form|
      expect(form).to have_selector("input[name='concern[title]']")
      expect(form).to have_selector("textarea[name='concern[description]']")
      expect(form).to have_selector("input[type='submit'][value='Submit Concern']")
      expect(form).to have_link("Back", href: member_concerns_path(existing_member))
    end
  end

  context "when there are errors" do
    before(:each) do
      @concern = Concern.new
      @concern.errors.add(:title, "can't be blank")
      @concern.errors.add(:description, "can't be blank")
      assign(:concern, @concern)
    end

    it "displays the error messages" do
      render
      expect(rendered).to have_selector("#error_explanation")
      expect(rendered).to have_selector("div#error_explanation h2", text: "2 errors prohibited this concern from being saved:")
      expect(rendered).to have_selector("div#error_explanation ul li", count: 2)
    end
  end
end
