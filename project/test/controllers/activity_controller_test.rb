require "test_helper"

class ActivityControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers # <-- Include helpers


  test "should get show" do
    sign_in users(:esteban12)
    # get group_url(groups(:animalesaaa))
    get activity_url(activities(:one_activity)), params: { id: activities(:one_activity).id }
    # Assertion for checking show.html.erb view
    assert_response :success
    assert_select 'h1', activities(:one_activity).name
  end
  # WIP: admin options for activities


  test "should create new activity" do
    assert_difference("Activity.count") do
      post activity_url, params: { activity: { title: "Some title" } }
    end

    assert_redirected_to article_path(Article.last)
    assert_equal "Article was successfully created.", flash[:notice]
  end

  test "should not create invalid activity" do
    assert_difference("Activity.count") do
      post activity_url, params: { activity: { location: "locationactivity" } }
    end

    assert_redirected_to activity_path(Activity.last)
    assert_equal "Activity was successfully created.", flash[:notice]
  end
end
