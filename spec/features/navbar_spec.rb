# spec/features/navbar_spec.rb

require 'rails_helper'

RSpec.feature "Navbar:", type: :feature do
  after(:each) do
    Member.destroy_all
  end

  scenario "Non-Admin user sees navigation links" do
    user = Member.create(full_name: "John Doe", email: "john@example.com", is_admin: false)

    omniauth_data = {
      provider: 'google_oauth2',
      uid: '123456',
      info: {
        email: user.email,
        name: user.full_name
      }
    }

    # Stub OmniAuth to simulate authentication
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(omniauth_data)

    visit root_path
    click_button 'Sign-In'

    expect(page).to have_link("Home")
    expect(page).to have_link("Members")
    expect(page).to have_link("Events")
    expect(page).to have_link("Announcements")

    expect(page).not_to have_link("Switch to Admin View")
  end

  scenario "Non-Member sees sign-in button when not signed in" do
    visit root_path

    expect(page).to have_link("Home")
    expect(page).to have_button("Sign-In")
    expect(page).not_to have_link("Members")
    expect(page).to have_link("Events")
    expect(page).to have_link("Announcements")
  end

  scenario "Admin user sees navigation links" do
    user = Member.create(full_name: "John Doe", email: "john@example.com", is_admin: true)

    omniauth_data = {
      provider: 'google_oauth2',
      uid: '123456',
      info: {
        email: user.email,
        name: user.full_name
      }
    }

    # Stub OmniAuth to simulate authentication
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(omniauth_data)

    visit root_path
    click_button 'Sign-In'
    # puts page.html

    expect(page).to have_link("Home")
    expect(page).to have_link("Members")
    expect(page).to have_link("Events")
    expect(page).to have_link("Announcements")

    expect(page).to have_link("Switch to Member View")
  end

  scenario "Admin user switches viewing modes" do
    user = Member.create(full_name: "John Doe", email: "john@example.com", is_admin: true)

    omniauth_data = {
      provider: 'google_oauth2',
      uid: '123456',
      info: {
        email: user.email,
        name: user.full_name
      }
    }

    # Stub OmniAuth to simulate authentication
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(omniauth_data)

    visit root_path
    click_button 'Sign-In'
    expect(page).to have_link("Switch to Member View")

    click_link "Switch to Member View"
    expect(page).to have_link("Switch to Admin View")
    
    click_link "Switch to Admin View"
    expect(page).to have_link("Switch to Member View")
  end
end