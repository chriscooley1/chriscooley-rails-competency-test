require "test_helper"

class ArticleTest < ActiveSupport::TestCase
  test "requires a title, content, and section" do
    article = Article.new

    assert_not article.valid?
    assert_includes article.errors[:title], "can't be blank"
    assert_includes article.errors[:content], "can't be blank"
    assert_includes article.errors[:section], "must be chosen, or add a new one"
  end

  test "rejects a title longer than 200 characters" do
    article = Article.new(title: "A" * 201, content: "Body", section: sections(:running))

    assert_not article.valid?
    assert_includes article.errors[:title], "is too long (maximum is 200 characters)"
  end

  test "a new section name is saved with the story" do
    article = Article.new(
      title: "Soup night",
      content: "The pot was already on.",
      user: users(:editor),
      new_section_name: "Cooking"
    )

    assert_difference "Section.count", 1 do
      assert article.save
    end
    assert_equal "Cooking", article.section.name
  end

  test "a repeated section name reuses the existing section" do
    assert_no_difference "Section.count" do
      article = Article.create!(
        title: "Another loop",
        content: "Same park, later start.",
        user: users(:editor),
        new_section_name: "running"
      )
      assert_equal sections(:running), article.section
    end
  end

  test "front page keeps the three newest stories in each section" do
    groups = Article.homepage_groups
    ultimate_titles = groups[sections(:ultimate)].map(&:title)

    assert_equal [ "Newest Ultimate", "Second Ultimate", "Third Ultimate" ], ultimate_titles
    assert_not_includes ultimate_titles, "Oldest Ultimate"
    assert_equal [ "Easy Miles" ], groups[sections(:running)].map(&:title)
    assert_equal [ sections(:ultimate), sections(:running), sections(:hiking), sections(:games) ], groups.keys
  end

  test "only the editor who wrote a story can manage it" do
    assert articles(:ultimate_newest).manageable_by?(users(:editor))
    assert_not articles(:games_story).manageable_by?(users(:editor))
    assert_not articles(:games_story).manageable_by?(users(:admin))
    assert_not articles(:ultimate_newest).manageable_by?(users(:reader))
    assert_not articles(:ultimate_newest).manageable_by?(nil)
  end
end
