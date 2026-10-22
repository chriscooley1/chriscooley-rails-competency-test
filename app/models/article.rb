class Article < ApplicationRecord
  CATEGORIES = [
    "Ultimate Frisbee",
    "Running",
    "Hiking",
    "Video Games"
  ].freeze

  validates :title, presence: true, length: { maximum: 200 }
  validates :content, presence: true
  validates :category, presence: true, inclusion: { in: CATEGORIES }

  scope :recent, -> { order(created_at: :desc, id: :desc) }

  def self.homepage_groups
    CATEGORIES.index_with do |category|
      recent.where(category: category).limit(3).to_a
    end
  end
end
