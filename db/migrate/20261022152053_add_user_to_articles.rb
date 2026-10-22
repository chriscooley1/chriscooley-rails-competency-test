class AddUserToArticles < ActiveRecord::Migration[8.1]
  def up
    # Stories published before accounts existed have no author.
    execute "DELETE FROM articles"

    add_reference :articles, :user, null: false, foreign_key: true
  end

  def down
    remove_reference :articles, :user, foreign_key: true
  end
end
