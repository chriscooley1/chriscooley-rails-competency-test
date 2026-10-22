require "test_helper"

class SectionTest < ActiveSupport::TestCase
  test "requires a name" do
    section = Section.new

    assert_not section.valid?
    assert_includes section.errors[:name], "can't be blank"
  end

  test "names are unique regardless of case" do
    section = Section.new(name: "running")

    assert_not section.valid?
    assert_includes section.errors[:name], "has already been taken"
  end
end
