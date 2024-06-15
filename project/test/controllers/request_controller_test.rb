require "test_helper"

class RequestControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers # <-- Include helpers

  test "should get user requests index" do
    sign_in users(:esteban12)
    get '/request'
    assert_response :success
    assert_select 'h2', 'Mis solicitudes'
  end


  test "should destroy request if user owns the request and request is pending" do
    sign_in users(:esteban12)
    
    # Assuming requests(:user_two_request_2) corresponds to a pending request owned by the signed-in user
    assert_difference("Request.count", -1) do
      delete request_path(requests(:user_two_request_2))
    end
    
    assert_redirected_to request_index_path
  
    follow_redirect!
    
    assert_equal 'Solicitud cancelada exitosamente.', flash[:success]
    assert_response :success
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


  # related to new request
  test "should create new request" do
    assert_difference("Request.count") do
      user = users(:user_that_has_no_requests)
      sign_in user
      post '/request',
           params: { user_id: user.id, group_id: 1, status: "pending", description: "aaasdadasds" }
    end
    assert_redirected_to request_path(Request.last)
  end
  test "should not create new request if user is admin of the group" do
    assert_no_difference("Request.count") do
      sign_in users(:esteban11)
      # post '/request', params: { request: { user_id: 1, group_id: 1, status: "pending", description: "dasdsda" } }
      post '/request', params: { user_id: 1, group_id: 1, status: "pending", description: "dasdsda" }
    end
    # assert_redirected_to '/request/'
  end

  test "should not create new request if user is a member of the group" do
    assert_no_difference("Request.count") do
      user = users(:esteban11)
      group = groups(:otakusaaa)
      sign_in user
      # post '/request', params: { request: { user_id: 1, group_id: 1, status: "pending", description: "dasdsda" } }
      post '/request', params: { user_id: user.id, group_id: group.id, status: "pending", description: "dasdsda" }
    end
    # assert_redirected_to '/request/'
  end

  # test "should not create new request if user already has a request created for that group" do
  #   assert_no_difference("Request.count") do
  #     sign_in users(:esteban11)
  #     Request.create(user_id: 1, group_id: )
  #     # post '/request', params: { request: { user_id: 1, group_id: 1, status: "pending", description: "dasdsda" } }
  #     post '/request', params: { user_id: 1, group_id: 1, status: "pending", description: "dasdsda" }
  #   end
  #   # assert_redirected_to '/request/'
  # end
  test "should not create new request if it has invalid group_id" do
    assert_no_difference("Request.count") do
      user = users(:user_that_has_no_requests)
      sign_in user
      post '/request',
           params: { user_id: user.id, group_id: "a", status: "pending", description: "aaasdadasds" }
    end
    assert_response :unprocessable_entity
    # assert_redirected_to request_path(Request.last)
  end

  test "should not create new request if it has no description" do
    assert_no_difference("Request.count") do
      user = users(:user_that_has_no_requests)
      sign_in user
      post '/request',
           params: { user_id: user.id, group_id: 1, status: "pending" }
    end
    assert_redirected_to '/' # TODO: this should redirect to create new request again, not to /
  end

  # tests related to show
  # TODO: these tests
  # test "should show request created by the user" do
  #   sign_in users(:esteban12)
  #   # get group_url(groups(:animalesaaa))
  #   get activity_url(activities(:one_activity)), params: { id: activities(:one_activity).id }
  #   # Assertion for checking show.html.erb view
  #   assert_response :success
  #   assert_select 'h1', activities(:one_activity).name
  # end
  # test "should show request from group that the user manages" do
  #   sign_in users(:esteban12)
  #   # get group_url(groups(:animalesaaa))
  #   get activity_url(activities(:one_activity)), params: { id: activities(:one_activity).id }
  #   # Assertion for checking show.html.erb view
  #   assert_response :success
  #   assert_select 'h1', activities(:one_activity).name
  # end
  test "should not show request that the user has no relation to" do
    user = users(:user_that_has_no_requests)
    request = requests(:one_request)
    sign_in user
    get request_url(request), params: { id: request.id }
    assert_response :forbidden
  end
end
