require 'rails_helper'

RSpec.describe "Announcements", type: :request do
  it "returns a successful response for the announcements index" do
    get announcements_path
    expect(response).to have_http_status(:success)
  end
end