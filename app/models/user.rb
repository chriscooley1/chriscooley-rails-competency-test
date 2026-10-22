class User < ApplicationRecord
  # :user is added by Petergate and is the reader role assigned at signup.
  # Admin is not a superset of editor. Admins cannot publish.
  petergate(roles: [ :admin, :editor ], multiple: false)

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :articles, dependent: :destroy

  ROLE_LABELS = {
    user: "Reader",
    editor: "Editor",
    admin: "Admin"
  }.freeze

  def role_label
    ROLE_LABELS.fetch(role.to_sym, role.to_s.humanize)
  end
end
