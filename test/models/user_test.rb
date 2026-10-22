require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "requires an email and password" do
    user = User.new

    assert_not user.valid?
    assert_includes user.errors[:email], "can't be blank"
    assert_includes user.errors[:password], "can't be blank"
  end
end
