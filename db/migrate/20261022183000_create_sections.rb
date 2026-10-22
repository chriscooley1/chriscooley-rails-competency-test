class CreateSections < ActiveRecord::Migration[8.1]
  def up
    create_table :sections do |t|
      t.string :name, null: false
      t.timestamps
    end

    add_reference :articles, :section, foreign_key: true, index: false

    known = [ "Ultimate Frisbee", "Running", "Hiking", "Video Games" ]
    existing = select_values("SELECT DISTINCT category FROM articles")
    (known + existing).uniq.each do |name|
      next if name.blank?

      now = Time.current
      execute <<~SQL.squish
        INSERT INTO sections (name, created_at, updated_at)
        VALUES (#{connection.quote(name)}, #{connection.quote(now)}, #{connection.quote(now)})
      SQL
      execute <<~SQL.squish
        UPDATE articles
        SET section_id = (SELECT id FROM sections WHERE name = #{connection.quote(name)})
        WHERE category = #{connection.quote(name)}
      SQL
    end

    change_column_null :articles, :section_id, false
    remove_index :articles, name: "index_articles_on_category_and_created_at"
    remove_column :articles, :category, :string
    add_index :articles, [ :section_id, :created_at ]
    execute "CREATE UNIQUE INDEX index_sections_on_lower_name ON sections (LOWER(name))"
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
