class KeywordSearchJob
  include Sidekiq::Worker
  sidekiq_options retry: 5, queue: :crawler


  def perform(keyword_id)
    keyword = Keyword.find_by(id: keyword_id)
    return unless keyword

    search_result = SearchService.perform_search(keyword.name)
    keyword.create_search_result!(
      total_ads: search_result[:total_adwords],
      total_links: search_result[:total_links],
      total_results: search_result[:total_results],
      html: search_result[:html_content] || 'failed',
    )
    keyword.update!(status: search_result[:status])
  end
end
