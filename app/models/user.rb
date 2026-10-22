class User < ApplicationRecord
  # :user is added by Petergate and is the reader role assigned at signup.
  # Admin is not a superset of editor. Admins manage accounts and cannot publish.
  petergate(roles: [ :admin, :editor ], multiple: false)

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :articles, dependent: :destroy

  ROLE_LABELS = {
    user: "Reader",
    editor: "Editor",
    admin: "Admin"
  }.freeze

  def self.role_options
    [ :user, :editor, :admin ].map { |role| [ ROLE_LABELS.fetch(role), role ] }
  end

  def role_label
    ROLE_LABELS.fetch(role.to_sym, role.to_s.humanize)
  end
end
