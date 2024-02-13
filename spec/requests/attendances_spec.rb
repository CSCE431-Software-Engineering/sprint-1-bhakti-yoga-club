require 'rails_helper'

RSpec.describe "Attendances", type: :request do
  it "returns a successful response for the attendances index" do
    get attendances_path
    expect(response).to have_http_status(:success)
  end

  describe 'GET /attendances/new' do
    it 'returns a successful response' do
      get new_attendance_path
      expect(response).to have_http_status(:success)
    end

    it 'renders the new template' do
      get new_attendance_path
      expect(response).to render_template(:new)
    end
  end

end