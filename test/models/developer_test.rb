require "test_helper"

class DeveloperTest < ActiveSupport::TestCase
  setup do
    @developer = developers :available
  end

  test "unspecified availability" do
    @developer.available_on = nil

    assert_equal "unspecified", @developer.availability_status
    assert @developer.available_unspecified?
  end

  test "available in a future date" do
    @developer.available_on = Date.today + 2.weeks

    assert_equal "in_future", @developer.availability_status
    assert @developer.available_in_future?
  end

  test "available from a past date" do
    @developer.available_on = Date.today - 3.weeks

    assert_equal "now", @developer.availability_status
    assert @developer.available_now?
  end

  test "available from today" do
    @developer.available_on = Date.today

    assert_equal "now", @developer.availability_status
    assert @developer.available_now?
  end

  test "is valid" do
    user = users(:with_available_profile)
    developer = Developer.new(user: user, name: "Foo", hero: "Bar", bio: "FooBar")

    assert developer.valid?
  end

  test "invalid without user" do
    developer = Developer.new(user: nil)

    refute developer.valid?
    assert_not_nil developer.errors[:user]
  end

  test "invalid without name" do
    user = users(:with_available_profile)
    developer = Developer.new(user: user, name: nil)

    refute developer.valid?
    assert_not_nil developer.errors[:name]
  end

  test "invalid without hero" do
    user = users(:with_available_profile)
    developer = Developer.new(user: user, hero: nil)

    refute developer.valid?
    assert_not_nil developer.errors[:hero]
  end

  test "invalid without bio" do
    user = users(:with_available_profile)
    developer = Developer.new(user: user, bio: nil)

    refute developer.valid?
    assert_not_nil developer.errors[:bio]
  end

  test "available scope is only available developers" do
    travel_to Time.zone.local(2021, 5, 4)

    developers = Developer.available

    assert_includes developers, developers(:available)
    refute_includes developers, developers(:unavailable)
  end
end
