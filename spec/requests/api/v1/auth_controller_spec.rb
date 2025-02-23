require 'rails_helper'

describe "Api::V1::AuthController", type: :request do
  describe "POST /api/v1/auth/sign_in" do
    let(:user) { create(:user, password: 'password123') } # Create a user with a known password

    context "with valid credentials" do
      it "returns a JWT token" do
        post "/api/v1/auth/sign_in", params: { email: user.email, password: 'password123' }
        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)
        expect(json_response).to have_key('token')

        decoded_token = JWT.decode(json_response['token'], Rails.application.secret_key_base, true, algorithm: 'HS256')
        expect(decoded_token[0]['user_id']).to eq(user.id)
        expect(decoded_token[0]['exp']).to be_present
      end
    end

    context "with invalid email" do
      it "returns unauthorized" do
        post "/api/v1/auth/sign_in", params: { email: 'wrong@example.com', password: 'password123' }
        expect(response).to have_http_status(:unauthorized)
        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to eq("Invalid email or password")
      end
    end

    context "with invalid password" do
      it "returns unauthorized" do
        post "/api/v1/auth/sign_in", params: { email: user.email, password: 'wrong_password' }
        expect(response).to have_http_status(:unauthorized)
        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to eq("Invalid email or password")
      end
    end
  end
end
