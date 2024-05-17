require "test_helper"

class RequestControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers # <-- Include helpers

  test "should get user requests index" do
    sign_in users(:esteban12)
    get '/request'
    assert_response :success
    assert_select 'h2', 'Mis Solicitudes'
    assert_select 'div', 'request_esteban12' # fixture user_two_request_1
  end


  test "should destroy request if user owns the request and request is pending" do
    sign_in users(:esteban12)
    assert_difference("Request.count", -1) do
      delete request_path(requests(:user_two_request_2))
    end
    assert_response :ok
  end

  test "should not destroy if user owns the request and request is not pending" do
    sign_in users(:esteban12)
    delete request_path(requests(:user_two_request_1))
    assert_redirected_to request_index_path
  end
  test "should not destroy request if request was not created by user" do
    sign_in users(:esteban11)
    delete request_path(requests(:user_two_request_1))
    assert_response :forbidden
  end

end
