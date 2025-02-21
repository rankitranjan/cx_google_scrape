require 'rails_helper'

describe "User Authentication", type: :request do
  let(:user) { create(:user) }

  describe "POST /users" do
    it "creates a new user" do
      expect {
        post user_registration_path, params: {
          user: { email: "test@example.com", password: "password123", password_confirmation: "password123" }
        }
      }.to change(User, :count).by(1)

      follow_redirect!
      expect(response.body).to include("Welcome! You have signed up successfully.")
    end
  end

  describe "DELETE /users" do
    before { sign_in user }

    it "deletes the user account" do
      expect {
        delete user_registration_path
      }.to change(User, :count).by(-1)

      expect(response).to have_http_status(:redirect)
      follow_redirect!
      expect(response.body).to include("Your account has been successfully cancelled.")
    end
  end

  describe "GET /users/sign_in" do
    it "renders the login page" do
      get new_user_session_path

      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /users/sign_in" do
    it "logs in a user with correct credentials" do
      post user_session_path, params: {
        user: {
          email: user.email,
          password: "password123"
        }
      }

      expect(response).to redirect_to(root_path)

      follow_redirect!
      expect(response.body).to include("Signed in successfully.")
    end

    it "fails with incorrect credentials" do
      post user_session_path, params: {
        user: {
          email: user.email,
          password: "wrongpassword"
        }
      }
      expect(response.body).to include("Invalid Email or password")
    end
  end

  describe "POST /users/password" do
    it "sends a password reset email" do
      post user_password_path, params: { user: { email: user.email } }

      expect(response).to have_http_status(:redirect)

      follow_redirect!
      expect(response.body).to include("You will receive an email with instructions on how to reset your password")
    end
  end

  describe "DELETE /users/sign_out" do
    before { sign_in user }

    it "logs out a user" do
      get destroy_user_session_path
      expect(response).to have_http_status(:redirect)
      follow_redirect!
      expect(response.body).to include("Signed out successfully")
    end
  end

  describe "PATCH /users" do
    before { sign_in user }

    it "updates user profile" do
      patch user_registration_path, params: {
        user: { email: "newemail@example.com", current_password: user.password }
      }

      expect(response).to have_http_status(:redirect)
      follow_redirect!
      expect(response.body).to include("Your account has been updated successfully.")
    end
  end  
end
