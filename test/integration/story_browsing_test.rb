require "test_helper"

class StoryBrowsingTest < ActionDispatch::IntegrationTest
  test "the front page shows the first three stories from each section" do
    get root_path

    assert_response :success
    assert_select "#category-ultimate-frisbee .story", 3
    assert_match "Newest Ultimate", response.body
    assert_no_match "Oldest Ultimate", response.body
    assert_no_match "UNIQUE_TAIL_MARKER", response.body
    Article::CATEGORIES.each do |category|
      assert_select "#category-#{category.parameterize}"
    end
  end

  test "the index includes older stories" do
    get articles_path

    assert_response :success
    assert_match "Oldest Ultimate", response.body
    assert_match "Easy Miles", response.body
    assert_no_match "UNIQUE_TAIL_MARKER", response.body
  end

  test "the index can be filtered by section" do
    get articles_path(category: "Ultimate Frisbee")

    assert_response :success
    assert_match "Oldest Ultimate", response.body
    assert_no_match "Easy Miles", response.body
  end

  test "an unknown section filter shows every story" do
    get articles_path(category: "Gossip")

    assert_response :success
    assert_match "Easy Miles", response.body
  end

  test "a story page shows the full text" do
    get article_path(articles(:ultimate_newest))

    assert_response :success
    assert_match "UNIQUE_TAIL_MARKER", response.body
  end
end
