require "test_helper"

class StoryPublishingTest < ActionDispatch::IntegrationTest
  test "anyone can publish a story" do
    assert_difference "Article.count", 1 do
      post articles_path, params: {
        article: {
          title: "Desk note",
          content: "Filed from the night desk.",
          category: "Running"
        }
      }
    end

    article = Article.find_by!(title: "Desk note")
    assert_redirected_to article_path(article)
  end

  test "a bad story shows validation errors" do
    post articles_path, params: { article: { title: "", content: "", category: "Gossip" } }

    assert_response :unprocessable_entity
    assert_select "#error_explanation"
  end

  test "anyone can update and delete a story" do
    article = articles(:ultimate_second)

    patch article_path(article), params: {
      article: { title: "Rewritten Ultimate", content: article.content, category: "Ultimate Frisbee" }
    }
    assert_redirected_to article_path(article)
    assert_equal "Rewritten Ultimate", article.reload.title

    assert_difference "Article.count", -1 do
      delete article_path(article)
    end
    assert_redirected_to articles_path
  end
end
