require 'rails_helper'

RSpec.describe "Events", type: :request do
  it "returns a successful response for the announcements index" do
    get events_path
    expect(response).to have_http_status(:success)
  end
end