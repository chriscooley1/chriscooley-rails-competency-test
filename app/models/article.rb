class Article < ApplicationRecord
  belongs_to :user
  belongs_to :section, autosave: true, optional: true

  attr_accessor :new_section_name

  validates :title, presence: true, length: { maximum: 200 }
  validates :content, presence: true
  validate :section_was_chosen

  before_validation :apply_new_section

  scope :recent, -> { order(created_at: :desc, id: :desc) }

  def self.homepage_groups
    Section.ordered.index_with do |section|
      recent.includes(:user).where(section_id: section.id).limit(3).to_a
    end
  end

  def manageable_by?(person)
    person.present? && person.has_role?(:editor) && person.id == user_id
  end

  private
    def apply_new_section
      name = new_section_name.to_s.strip
      return if name.blank?

      if name.length > Section::MAX_NAME
        errors.add(:new_section_name, "is too long (maximum is #{Section::MAX_NAME} characters)")
        return
      end

      self.section = Section.named(name) || Section.new(name: name)
    end

    def section_was_chosen
      return if section.present? || errors[:new_section_name].any?

      errors.add(:section, "must be chosen, or add a new one")
    end
end
