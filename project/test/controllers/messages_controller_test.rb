require "test_helper"

class MessagesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers # <-- Include helpers

  test "should create new message" do
    assert_difference("Message.count") do
      sign_in users(:esteban11)
      post messages_url, params: { message: { user_id: 1, group_id: 1, content: "Lorem ipsum" } }
    end
    assert_response :created
  end

  test "should not create new message from different user" do
    sign_in users(:esteban11)
    assert_no_difference("Message.count") do
      post messages_url, params: { message: { user_id: 2, group_id: 1,  content: "Lorem ipsum et al" } }
    end
    assert_response :forbidden
  end
  # wip, should not create invalid message
  test "should not create invalid message" do
    assert_no_difference("Message.count") do
      sign_in users(:esteban11)
      post messages_url, params: { message: { user_id: 1, content: "Lorem ipsum" } }
    end
    assert_response :unprocessable_entity
  end

end
