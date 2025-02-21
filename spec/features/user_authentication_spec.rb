require 'rails_helper'

RSpec.feature "User Authentication", type: :feature do
  let(:user) { create(:user) }

  scenario "User signs in successfully" do
    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "password123"
    click_button "Log in"

    expect(page).to have_content("Signed in successfully")
  end

  scenario "User fails to sign in with incorrect credentials" do
    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "wrongpassword"
    click_button "Log in"

    expect(page).to have_content("Invalid Email or password")
  end

  scenario "User logs out" do
    login_as(user, scope: :user)
    visit root_path
    click_link "Logout"

    expect(page).to have_content("Signed out successfully")
  end
end
