require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "requires an email and password" do
    user = User.new

    assert_not user.valid?
    assert_includes user.errors[:email], "can't be blank"
    assert_includes user.errors[:password], "can't be blank"
  end

  test "signup leaves the person as a reader" do
    user = User.create!(email: "new@example.com", password: "password123")

    assert user.has_role?(:user)
    assert_not user.has_role?(:editor)
    assert_not user.has_role?(:admin)
  end
end
