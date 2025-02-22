require 'rails_helper'

describe SearchResult, type: :model do
  let(:user) { create(:user) }
  let(:keyword) { create(:keyword, user: user) } 

  before do
    allow(SearchService).to receive(:perform_search).and_return(
      total_adwords: 5,
      total_links: 100,
      total_results: 5000,
      html_content: "<html>some html</html>",
      status: 'completed'
    )
  end

  it "is valid with valid attributes" do
    search_result = SearchResult.new(
      keyword: keyword,
      total_ads: 3,
      total_links: 15,
      total_results: 2000000,
      html: "<html>Google Search Page</html>"
    )
    expect(search_result).to be_valid
  end

  it "is invalid without total_ads" do
    search_result = SearchResult.new(total_ads: nil)
    expect(search_result).not_to be_valid
    expect(search_result.errors[:total_ads]).to include("can't be blank")
  end

  it "is invalid without total_links" do
    search_result = SearchResult.new(total_links: nil)
    expect(search_result).not_to be_valid
    expect(search_result.errors[:total_links]).to include("can't be blank")
  end

  it "is invalid without total_results" do
    search_result = SearchResult.new(total_results: nil)
    expect(search_result).not_to be_valid
    expect(search_result.errors[:total_results]).to include("can't be blank")
  end

  it "is invalid with negative total_ads" do
    search_result = SearchResult.new(total_ads: -1)
    expect(search_result).not_to be_valid
    expect(search_result.errors[:total_ads]).to include("must be greater than or equal to 0")
  end

  it "is invalid without html" do
    search_result = SearchResult.new(html: nil)
    expect(search_result).not_to be_valid
    expect(search_result.errors[:html]).to include("can't be blank")
  end
end
