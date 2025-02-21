class Keyword < ApplicationRecord
  belongs_to :user
  validates :name, presence: true, uniqueness: { scope: :user_id }

  enum status: { pending: 0, completed: 1, failed: 2 }
end
