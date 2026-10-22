class Section < ApplicationRecord
  MAX_NAME = 40

  has_many :articles, dependent: :restrict_with_error

  validates :name, presence: true, length: { maximum: MAX_NAME }, uniqueness: { case_sensitive: false }

  scope :ordered, -> { order(:created_at, :id) }

  def self.named(name)
    where("LOWER(name) = ?", name.to_s.strip.downcase).first
  end
end
