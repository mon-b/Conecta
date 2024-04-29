require "test_helper"

class ActivityControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers # <-- Include helpers
  test "should get index" do
    sign_in users(:esteban12)
    get activity_index_url
    assert_response :success
  end

  test "should get show" do
    get activity_show_url
    assert_response :success
  end

  test "should get new" do
    get activity_new_url
    assert_response :success
  end

  test "should get edit" do
    get activity_edit_url
    assert_response :success
  end
end
