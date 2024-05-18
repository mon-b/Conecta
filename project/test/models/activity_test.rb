require "test_helper"

class ActivityTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "activity should downcase location and keywords" do
    activity = activities(:one_activity)
    activity.location = "LOCATION"
    activity.keywords = "KEYWORDSAA"
    activity.save!
    assert_equal "location", activity.location
    assert_equal "keywordsaa", activity.keywords
  end
end
