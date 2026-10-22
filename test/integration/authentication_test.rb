require "test_helper"

class AuthenticationTest < ActionDispatch::IntegrationTest
  test "signup returns the visitor to the story they tried to read" do
    article = articles(:ultimate_newest)
    get article_path(article)
    assert_redirected_to new_user_registration_path

    post user_registration_path, params: {
      user: {
        email: "reader2@example.com",
        password: "password123",
        password_confirmation: "password123"
      }
    }

    assert_redirected_to article_path(article)
    follow_redirect!
    assert_match "UNIQUE_TAIL_MARKER", response.body
  end

  test "a reader can log in and log out" do
    post user_session_path, params: { user: { email: users(:reader).email, password: "password123" } }
    assert_redirected_to root_path

    delete destroy_user_session_path
    assert_redirected_to root_path
    follow_redirect!
    assert_select "a", text: "Log in"
  end
end
