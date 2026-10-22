class CreateArticles < ActiveRecord::Migration[8.1]
  def change
    create_table :articles do |t|
      t.string :title, null: false
      t.text :content, null: false
      t.string :category, null: false

      t.timestamps
    end

    add_index :articles, [ :category, :created_at ]
  end
end
