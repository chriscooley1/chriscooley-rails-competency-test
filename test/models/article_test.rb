require "test_helper"

class ArticleTest < ActiveSupport::TestCase
  test "requires a title, content, and known section" do
    article = Article.new

    assert_not article.valid?
    assert_includes article.errors[:title], "can't be blank"
    assert_includes article.errors[:content], "can't be blank"
    assert_includes article.errors[:category], "can't be blank"

    article.category = "Gossip"
    article.validate
    assert_includes article.errors[:category], "is not included in the list"
  end

  test "rejects a title longer than 200 characters" do
    article = Article.new(title: "A" * 201, content: "Body", category: "Running")

    assert_not article.valid?
    assert_includes article.errors[:title], "is too long (maximum is 200 characters)"
  end

  test "front page keeps the three newest stories in each section" do
    groups = Article.homepage_groups
    ultimate_titles = groups["Ultimate Frisbee"].map(&:title)

    assert_equal [ "Newest Ultimate", "Second Ultimate", "Third Ultimate" ], ultimate_titles
    assert_not_includes ultimate_titles, "Oldest Ultimate"
    assert_equal [ "Easy Miles" ], groups["Running"].map(&:title)
    assert_equal Article::CATEGORIES, groups.keys
  end

  test "only the editor who wrote a story can manage it" do
    assert articles(:ultimate_newest).manageable_by?(users(:editor))
    assert_not articles(:games_story).manageable_by?(users(:editor))
    assert_not articles(:games_story).manageable_by?(users(:admin))
    assert_not articles(:ultimate_newest).manageable_by?(users(:reader))
    assert_not articles(:ultimate_newest).manageable_by?(nil)
  end
end
