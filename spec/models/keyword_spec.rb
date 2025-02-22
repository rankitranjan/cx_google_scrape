require 'rails_helper'

describe Keyword, type: :model do
  before do
    allow(SearchService).to receive(:perform_search).and_return(
      total_adwords: 5,
      total_links: 100,
      total_results: 5000,
      html_content: "<html>some html</html>",
      status: 'completed'
    )
  end
  
  describe "Validations" do
    let(:user) { User.create!(email: "test@example.com", password: "password") }

    it "is valid with a name and a user" do
      keyword = Keyword.new(name: "Rails Testing", user: user)
      expect(keyword).to be_valid
    end

    it "is invalid without a name" do
      keyword = Keyword.new(name: nil, user: user)
      expect(keyword).not_to be_valid
      expect(keyword.errors[:name]).to include("can't be blank")
    end

    it "is invalid if the name is not unique for the same user" do
      Keyword.create!(name: "Ruby on Rails", user: user)
      duplicate_keyword = Keyword.new(name: "Ruby on Rails", user: user)
      expect(duplicate_keyword).not_to be_valid
      expect(duplicate_keyword.errors[:name]).to include("has already been taken")
    end

    it "allows the same name for different users" do
      another_user = User.create!(email: "other@example.com", password: "password")
      Keyword.create!(name: "Ruby on Rails", user: user)
      keyword = Keyword.new(name: "Ruby on Rails", user: another_user)
      expect(keyword).to be_valid
    end

    it "is invalid without a user" do
      keyword = Keyword.new(name: "Rails Testing", user: nil)
      expect(keyword).not_to be_valid
      expect(keyword.errors[:user]).to include("must exist")
    end
  end
end
