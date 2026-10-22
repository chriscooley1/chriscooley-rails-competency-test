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

  test "a reader is turned away from publishing" do
    sign_in users(:reader)

    get new_article_path
    assert_redirected_to root_path

    assert_no_difference "Article.count" do
      post articles_path, params: {
        article: { title: "Nope", content: "Nope", category: "Running" }
      }
    end
    assert_redirected_to root_path
    assert_equal "You do not have permission to change articles.", flash[:notice]
  end

  test "an editor can publish a story attributed to themselves" do
    sign_in users(:editor)

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
    assert_equal users(:editor), article.user
    assert_redirected_to article_path(article)
  end

  test "a bad story shows validation errors" do
    sign_in users(:editor)
    post articles_path, params: { article: { title: "", content: "", category: "Gossip" } }

    assert_response :unprocessable_entity
    assert_select "#error_explanation"
  end

  test "an editor can update and delete only their own story" do
    sign_in users(:editor)
    article = articles(:ultimate_second)
    other = articles(:games_story)

    patch article_path(article), params: {
      article: { title: "Rewritten Ultimate", content: article.content, category: "Ultimate Frisbee" }
    }
    assert_redirected_to article_path(article)
    assert_equal "Rewritten Ultimate", article.reload.title

    patch article_path(other), params: {
      article: { title: "Hijacked", content: other.content, category: other.category }
    }
    assert_redirected_to articles_path
    assert_equal "You can only edit or delete stories you created.", flash[:alert]
    assert_equal "One More Run", other.reload.title

    assert_difference "Article.count", -1 do
      delete article_path(article)
    end
    assert_redirected_to articles_path
  end
end
