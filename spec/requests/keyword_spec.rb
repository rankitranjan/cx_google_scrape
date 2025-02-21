require 'rails_helper'

describe "Keywords", type: :request do
  let(:user) { User.create!(email: "test@example.com", password: "password") }
  let!(:keyword) { Keyword.create!(name: "Rails Testing", user: user) }

  before do
    sign_in user
  end

  describe "GET /index" do
    it "returns a successful response" do
      get keywords_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Rails Testing")
    end
  end

  describe "GET /new" do
    it "returns a successful response" do
      get new_keyword_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /create" do
    let(:file) { fixture_file_upload(Rails.root.join("spec/fixtures/files/sample.csv"), "text/csv") }

    context "with valid file" do
      it "creates keywords and redirects" do
        allow(CsvParser).to receive(:parse).and_return(["Weather", "Amazon"])
        allow(KeywordProcessor).to receive(:process).and_return(["Weather", "Amazon"])

        post keywords_path, params: { keyword: { file: file } }

        expect(response).to redirect_to(keywords_path)
        follow_redirect!
        expect(response.body).to include("Keywords processed successfully.")
      end
    end

    context "with missing file" do
      it "returns an error" do
        post keywords_path, params: { keyword: { file: nil } }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("No file provided")
      end
    end
  end

  describe "GET /show/:id" do
    it "returns a successful response" do
      get keyword_path(keyword)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Rails Testing")
    end
  end

  describe "DELETE /destroy/:id" do
    it "deletes the keyword and redirects" do
      expect {
        delete keyword_path(keyword)
      }.to change(Keyword, :count).by(-1)

      expect(response).to redirect_to(keywords_path)
      follow_redirect!
      expect(response.body).to include("Keyword was successfully destroyed.")
    end
  end

  describe "GET /sample_csv" do
    it "returns a sample CSV file" do
      get sample_csv_keywords_path
      expect(response).to have_http_status(:ok)
      expect(response.headers["Content-Type"]).to include("text/csv")
      expect(response.body).to include("Keywords\nWeather\nAmazon\nDefine")
    end
  end
end
