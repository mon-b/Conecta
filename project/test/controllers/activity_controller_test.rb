require "test_helper"

class ActivityControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers # <-- Include helpers


  test "should get show" do
    sign_in users(:esteban12)
    # get group_url(groups(:animalesaaa))
    activity = activities(:one_activity)
    get activity_url(activity), params: { id: activity.id }
    # Assertion for checking show.html.erb view
    assert_response :success

    # danger: there is a span there
    assert_select 'h3', activity.name + "  " + activity.keywords
  end
  # WIP: admin options for activities


  test "should create new activity" do
    sign_in users(:esteban11)
    assert_difference("Activity.count") do
      post '/activity',
           params: { activity: { group_id: 1, name: "title" , location: "aa", date: DateTime.now, keywords: "aaa",
           description: "golas dasd", cost: 100, people: 50  } }
    end
    assert_redirected_to activity_path(Activity.last)
  end

  test "should not create invalid activity" do
    sign_in users(:esteban11)
    assert_no_difference("Activity.count") do
      post '/activity', params: { activity: { location: "locationactivity" } }
    end
    assert_redirected_to '/new' # TODO: fix this
  end
end

# TODO: test to not create activity if user is not member/admin
# test "should not create invalid activity" do
#   assert_difference("Activity.count") do
#     post activity_url, params: { activity: { location: "locationactivity" } }
#   end

#   assert_redirected_to activity_path(Activity.last)
#   assert_equal "Activity was successfully created.", flash[:notice]
# end
# end
