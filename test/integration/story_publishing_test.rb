require "test_helper"

class StoryPublishingTest < ActionDispatch::IntegrationTest
  test "a guest is sent to log in before publishing" do
    get new_article_path
    assert_redirected_to new_user_session_path

    assert_no_difference "Article.count" do
      post articles_path, params: {
        article: { title: "Nope", content: "Nope", section_id: sections(:running).id }
      }
    end
    assert_redirected_to new_user_session_path
  end

  test "a reader is turned away from publishing" do
    sign_in users(:reader)

    get new_article_path
    assert_redirected_to root_path

    assert_no_difference [ "Article.count", "Section.count" ] do
      post articles_path, params: {
        article: { title: "Nope", content: "Nope", new_section_name: "Travel" }
      }
    end
    assert_redirected_to root_path
    assert_equal "You do not have permission to change articles.", flash[:notice]
    assert_nil Section.named("Travel")
  end

  test "an editor can publish a story attributed to themselves" do
    sign_in users(:editor)

    assert_difference "Article.count", 1 do
      post articles_path, params: {
        article: {
          title: "Desk note",
          content: "Filed from the night desk.",
          section_id: sections(:running).id
        }
      }
    end

    article = Article.find_by!(title: "Desk note")
    assert_equal users(:editor), article.user
    assert_equal sections(:running), article.section
    assert_redirected_to article_path(article)
  end

  test "an editor can add a section by publishing a story in it" do
    sign_in users(:editor)

    assert_difference [ "Article.count", "Section.count" ], 1 do
      post articles_path, params: {
        article: {
          title: "Late train",
          content: "The platform was empty.",
          new_section_name: "Travel"
        }
      }
    end

    article = Article.find_by!(title: "Late train")
    assert_equal "Travel", article.section.name

    get root_path
    assert_select "#category-travel", text: /Late train/
    get articles_path
    assert_select "a", text: "Travel"
    get new_article_path
    assert_select "option", text: "Travel"
  end

  test "a bad story shows validation errors" do
    sign_in users(:editor)
    post articles_path, params: { article: { title: "", content: "", new_section_name: "Gossip" } }

    assert_response :unprocessable_entity
    assert_select "#error_explanation"
    assert_nil Section.named("Gossip")
  end

  test "an editor can update and delete only their own story" do
    sign_in users(:editor)
    article = articles(:ultimate_second)
    other = articles(:games_story)

    patch article_path(article), params: {
      article: { title: "Rewritten Ultimate", content: article.content, section_id: sections(:ultimate).id }
    }
    assert_redirected_to article_path(article)
    assert_equal "Rewritten Ultimate", article.reload.title

    patch article_path(other), params: {
      article: { title: "Hijacked", content: other.content, section_id: other.section_id }
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
