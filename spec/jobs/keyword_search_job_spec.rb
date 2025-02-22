require 'rails_helper'

RSpec.describe KeywordSearchJob, type: :job do
  let(:user) { create(:user) }
  let(:keyword) { create(:keyword, status: :pending, user: user) }

  before do
    allow(SearchService).to receive(:perform_search).and_return(
      total_adwords: 5,
      total_links: 100,
      total_results: 5000,
      html_content: "<html>some html</html>",
      status: 'completed'
    )
  end

  describe '#perform' do
    it 'enqueues the job correctly when a pending keyword is created' do
      Sidekiq::Testing.fake!

      # Expect the job to be enqueued when creating a pending keyword
      expect {
        create(:keyword, status: :pending, user: user)
      }.to change(KeywordSearchJob.jobs, :size).by(1)
    end

    it 'performs the job and updates the keyword status' do
      Sidekiq::Testing.inline!

      expect(keyword.reload.status).to eq('completed')
      expect(keyword.search_result).not_to be_nil
      expect(keyword.search_result.total_ads).to eq(5)
      expect(keyword.search_result.total_links).to eq(100)
      expect(keyword.search_result.total_results).to eq("5000")
    end

    it 'does not perform the job if the keyword is not pending' do
      keyword.update!(status: :completed) # Change status to completed

      expect(KeywordSearchJob.jobs.size).to eq(0)
    end
  end

  describe 'error handling' do
    it 'handles errors gracefully if SearchService fails' do
      allow(SearchService).to receive(:perform_search).and_return(
        total_adwords: 0,
        total_links: 0,
        total_results: 0,
        html_content: '<html>some html</html>"',
        status: 'failed'
      )

      expect(keyword.reload.status).to eq('failed')
      expect(keyword.reload.search_result).not_to be_nil
    end
  end
end
