class Keyword < ApplicationRecord
  enum :status, [:pending, :completed, :failed], default: :pending
  validates :name, presence: true, uniqueness: { scope: :user_id }

  belongs_to :user
  has_one :search_result, dependent: :destroy

  after_create_commit :enqueue_search_job

  delegate :total_ads, :total_links, :total_results, :html, to: :search_result, allow_nil: true

  def refresh
    KeywordSearchJob.perform_async(self.id)
  end

  private

  def enqueue_search_job
    return unless self.pending?

    KeywordSearchJob.perform_async(self.id)
  end
end
