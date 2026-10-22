require "test_helper"

class StoryPublishingTest < ActionDispatch::IntegrationTest
  test "a guest is sent to log in before publishing" do
    get new_article_path
    assert_redirected_to new_user_session_path

    assert_no_difference "Article.count" do
      post articles_path, params: {
        article: { title: "Nope", content: "Nope", category: "Running" }
      }
    end
    assert_redirected_to new_user_session_path
  end

  test "a signed-in reader can publish a story attributed to themselves" do
    sign_in users(:reader)

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
    assert_equal users(:reader), article.user
    assert_redirected_to article_path(article)
  end

  test "a bad story shows validation errors" do
    sign_in users(:reader)
    post articles_path, params: { article: { title: "", content: "", category: "Gossip" } }

    assert_response :unprocessable_entity
    assert_select "#error_explanation"
  end

  test "a signed-in reader can update and delete a story" do
    sign_in users(:reader)
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
