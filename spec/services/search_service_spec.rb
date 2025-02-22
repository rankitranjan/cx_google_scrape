require 'rails_helper'
require 'playwright'

RSpec.describe SearchService, type: :service do
  let(:mock_playwright) { instance_double(Playwright::Playwright) } # Fixed this line
  let(:mock_browser) { instance_double(Playwright::Browser) }
  let(:mock_context) { instance_double(Playwright::BrowserContext) }
  let(:mock_page) { instance_double(Playwright::Page) }

  let(:keyword) { "ruby on rails" }
  let(:search_url) { "https://www.google.com/search?q=#{URI.encode_www_form_component(keyword)}" }

  before do
    allow(Playwright).to receive(:create).and_yield(mock_playwright)
    allow(mock_playwright).to receive_message_chain(:chromium, :launch).and_return(mock_browser) # Fixed this line
    allow(mock_browser).to receive(:new_context).and_return(mock_context)
    allow(mock_context).to receive(:new_page).and_return(mock_page)
    allow(mock_browser).to receive(:close)
  end

  describe '.perform_search' do
    context 'when search executes successfully' do
      before do
        allow(mock_page).to receive(:set_viewport_size)
        allow(mock_page).to receive(:set_extra_http_headers)
        allow(mock_page).to receive(:goto).with(search_url, timeout: 60_000)
        allow(mock_page).to receive(:evaluate).with("window.scrollBy(0, document.body.scrollHeight)")
        allow(mock_page).to receive(:content).and_return("<html>Mock HTML Content</html>")

        # Mocking element counts
        allow(mock_page).to receive_message_chain(:locator, :count).and_return(3)
        allow(mock_page).to receive(:text_content).with('#result-stats').and_return("About 10,000 results")
      end

      it 'returns valid search results' do
        result = SearchService.perform_search(keyword)

        expect(result[:status]).to eq('completed')
        expect(result[:total_adwords]).to eq(3)
        expect(result[:total_links]).to eq(3)
        expect(result[:total_results]).to eq(10000)
        expect(result[:html_content]).to include("Mock HTML Content")
      end
    end

    context 'when an error occurs during search' do
      before do
        allow(mock_page).to receive(:set_viewport_size)
        allow(mock_page).to receive(:set_extra_http_headers)
        allow(mock_page).to receive(:goto).and_raise(StandardError.new("Timeout error"))
      end

      it 'handles errors gracefully' do
        result = SearchService.perform_search(keyword)

        expect(result[:status]).to eq('failed')
        expect(result[:total_adwords]).to eq(0)
        expect(result[:total_links]).to eq(0)
        expect(result[:total_results]).to eq(0)
        expect(result[:html_content]).to eq("")
      end
    end
  end
end
