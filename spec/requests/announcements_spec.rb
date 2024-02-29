require 'rails_helper'

RSpec.describe "Announcements", type: :request do
  it "returns a successful response for the announcements index" do
    get announcements_path
    expect(response).to have_http_status(:success)
  end

  describe 'GET /announcements/new' do
    it 'returns a successful response' do
      get new_announcement_path
      expect(response).to have_http_status(:success)
    end

    it 'renders the new template' do
      get new_announcement_path
      expect(response).to render_template(:new)
    end
  end

end