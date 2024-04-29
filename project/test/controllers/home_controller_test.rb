require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers # <-- Include helpers
  test "should get index" do
    get home_index_url
    assert_response :success
  end
end
