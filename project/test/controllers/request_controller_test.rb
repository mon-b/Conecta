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

end
