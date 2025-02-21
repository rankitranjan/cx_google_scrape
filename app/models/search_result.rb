class SearchResult < ApplicationRecord
  belongs_to :keyword

  validates :total_ads, :total_links, :total_results, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :html, presence: true
end
