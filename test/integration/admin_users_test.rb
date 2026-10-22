require "test_helper"

class AdminUsersTest < ActionDispatch::IntegrationTest
  test "an admin can create a user and set a role" do
    sign_in users(:admin)

    assert_difference "User.count", 1 do
      post admin_users_path, params: {
        user: {
          email: "night@example.com",
          password: "password123",
          password_confirmation: "password123",
          role: "editor"
        }
      }
    end

    created = User.find_by!(email: "night@example.com")
    assert_equal :editor, created.role
    assert created.has_role?(:editor)
    assert created.valid_password?("password123")
    assert_redirected_to admin_users_path
  end

  test "an admin can change a role without resetting the password" do
    sign_in users(:admin)
    reader = users(:reader)

    patch admin_user_path(reader), params: {
      user: { email: reader.email, role: "editor", password: "", password_confirmation: "" }
    }

    assert_redirected_to admin_users_path
    reader.reload
    assert_equal :editor, reader.role
    assert reader.valid_password?("password123")
  end

  test "an admin sees validation errors for a bad account" do
    sign_in users(:admin)
    post admin_users_path, params: {
      user: { email: "", password: "short", password_confirmation: "short", role: "user" }
    }

    assert_response :unprocessable_entity
    assert_select "#error_explanation", text: /kept this account from saving/
  end

  test "an unknown role stays a reader" do
    sign_in users(:admin)

    post admin_users_path, params: {
      user: {
        email: "plain@example.com",
        password: "password123",
        password_confirmation: "password123",
        role: "owner"
      }
    }

    created = User.find_by!(email: "plain@example.com")
    assert created.has_role?(:user)
    assert_not created.has_role?(:editor)
    assert_not created.has_role?(:admin)
  end

  test "readers and editors cannot manage users" do
    sign_in users(:reader)
    get admin_users_path
    assert_redirected_to root_path
    assert_equal "Only admins can manage users.", flash[:notice]

    sign_in users(:editor)
    assert_no_difference "User.count" do
      post admin_users_path, params: {
        user: {
          email: "blocked@example.com",
          password: "password123",
          password_confirmation: "password123",
          role: "admin"
        }
      }
    end
    assert_redirected_to root_path
    assert_nil User.find_by(email: "blocked@example.com")
  end

  test "a guest is sent to login from the people page" do
    get admin_users_path
    assert_redirected_to new_user_session_path
  end

  test "only an admin sees the people link" do
    get root_path
    assert_select "a", text: "People", count: 0

    sign_in users(:editor)
    get root_path
    assert_select "a", text: "People", count: 0

    sign_in users(:admin)
    get root_path
    assert_select "a", text: "People"
  end
end
