require 'rails_helper'

RSpec.describe "Pages", type: :request do
  it "returns a successful response for the home page" do
    get root_path
    expect(response).to have_http_status(:success)
  end
end
