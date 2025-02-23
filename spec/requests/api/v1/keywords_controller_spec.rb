# spec/requests/api/v1/keywords_controller_spec.rb
require 'rails_helper'

RSpec.describe "Api::V1::KeywordsController", type: :request do
  let(:user) { create(:user) }
  let(:payload) { { user_id: user.id, exp: 24.hours.from_now.to_i  } }
  let(:token) { JWT.encode(payload, Rails.application.secret_key_base, 'HS256') }
  let(:client_id) { SecureRandom.base64(8) }

  let(:auth_headers) do
    {
      'Authorization' => "Bearer #{token}",
      'client' => client_id,
      'user_id' => user.id
    }
  end

  before do
    allow(SearchService).to receive(:perform_search).and_return(
      total_adwords: 5,
      total_links: 100,
      total_results: 5000,
      html_content: "<html>some html</html>",
      status: 'completed'
    )
  end

  describe "GET /api/v1/keywords" do
    let!(:keywords) { create_list(:keyword, 3, user: user) }

    it "returns paginated keywords with metadata" do
      get "/api/v1/keywords", headers: auth_headers
      expect(response).to have_http_status(:ok)

      json_response = JSON.parse(response.body)
      expect(json_response["keywords"].length).to eq(3)
      expect(json_response["meta"]["current_page"]).to eq(1)
      expect(json_response["meta"]["total_count"]).to eq(3)
      expect(json_response["meta"]).to have_key("total_pages")
    end

    it "returns correct pagination with params" do
      create_list(:keyword, 7, user: user)
      get "/api/v1/keywords?page=2&per_page=5", headers: auth_headers
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response["keywords"].length).to eq(5)
      expect(json_response["meta"]["current_page"]).to eq(2)
      expect(json_response["meta"]["total_count"]).to eq(10)
    end
  end

  describe "POST /api/v1/keywords/upload" do
    let(:csv_file) { fixture_file_upload('sample.csv', 'text/csv') }

    before do
      allow(CsvParser).to receive(:parse).and_return(["keyword1", "keyword2"])
      allow(KeywordProcessor).to receive(:process).and_return(["keyword1", "keyword2"])
    end

    it "uploads keywords from CSV" do
      post "/api/v1/keywords/upload", params: { file: csv_file }, headers: auth_headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to eq("File uploaded successfully")
      expect(user.keywords.count).to eq(2)
    end

    it "returns error if no file uploaded" do
      post "/api/v1/keywords/upload", headers: auth_headers
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["error"]).to eq("No file uploaded")
    end
  end

  describe "GET /api/v1/search" do
    let!(:keyword1) { create(:keyword, name: "test keyword", user: user) }
    let!(:keyword2) { create(:keyword, name: "another keyword", user: user) }

    it "returns searched keywords" do
      get "/api/v1/search?q=test", headers: auth_headers
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response["keywords"].length).to eq(1)
      expect(json_response["keywords"][0]["name"]).to eq("test keyword")
    end

    it "returns none if search term is empty" do
      get "/api/v1/search", headers: auth_headers
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response["keywords"].length).to eq(0)
    end

    it "returns correct pagination with params" do
      create_list(:keyword, 7, user: user)
      get "/api/v1/search?q=name_&page=2&per_page=5", headers: auth_headers
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)

      expect(json_response["meta"]["current_page"]).to eq(2)
      expect(json_response["meta"]["total_count"]).to eq(7)
    end
  end
end
