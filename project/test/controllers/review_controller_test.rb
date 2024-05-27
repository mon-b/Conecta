require "test_helper"

class ReviewControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers # <-- Include helpers

  # related to new review
  test "should create new review" do
    user = users(:esteban11)
    activity = activities(:one_activity)
    assert_difference("Review.count") do
      sign_in user
      post '/reviews',
           params: { review: {user_id: user.id, activity_id: activity.id, rating: 3.1, title: "uwu",
body: "Lorem ipsum"} }
    end
    assert_redirected_to activity
    # request_path(Request.last)
  end

  test "should not create new review without title" do
    user = users(:esteban11)
    activity = activities(:one_activity)
    assert_no_difference("Review.count") do
      sign_in user
      post '/reviews',
           params: { review: {user_id: user.id, activity_id: activity.id, rating: 3.1, body: "Lorem ipsum"} }
    end
    # assert_redirected_to activity
    # request_path(Request.last)
  end

  test "should not create review if user is not a member of the group associated to the activity" do
    user = users(:user_that_has_no_groups)
    activity = activities(:one_activity)
    assert_no_difference("Review.count") do
      sign_in user
      post '/reviews',
           params: { review: {user_id: user.id, activity_id: activity.id, rating: 3.1, title: "uwu",
              body: "Lorem ipsum"} }
    end
    # assert_redirected_to activity
    # request_path(Request.last)
  end

  # TODO: test for no duplicate reviews
  # test "should not create new request if user already has a request created for that group" do
  #   assert_no_difference("Request.count") do
  #     sign_in users(:esteban11)
  #     Request.create(user_id: 1, group_id: )
  #     # post '/request', params: { request: { user_id: 1, group_id: 1, status: "pending", description: "dasdsda" } }
  #     post '/request', params: { user_id: 1, group_id: 1, status: "pending", description: "dasdsda" }
  #   end
  #   # assert_redirected_to '/request/'
  # end

  # wip fix test
  # test "should not create new review if it has invalid activity_id" do
  #   assert_no_difference("Review.count") do
  #     user = users(:esteban11)
  #     sign_in user
  #     post '/request',
  #          params: { review: {user_id: user.id, rating: 3.1, title: "uwu",
  #          body: "Lorem ipsum"} }
  #   end
  #   assert_redirected_to request_path(Request.last)
  # end



  # tests related to edit
  test "should get the edit page for a review that i created" do
    sign_in users(:esteban11)
    get edit_review_url(reviews(:one_review))
    assert_response :success
    assert_select 'h2', 'Editar reseña'
  end

  test "should not get the edit page for a review that i did not create" do
    sign_in users(:esteban12)
    get edit_review_url(reviews(:one_review))
    assert_response :forbidden
  end

  # TODO: tests related to update
  test "should update review for a review that i created" do
    sign_in users(:esteban11)
    review = reviews(:one_review)

    patch review_url(review), params: { review: { rating: 1.5 } }

    assert_redirected_to review_path(review)
    # Reload association to fetch updated data and assert that title is updated.
    review.reload
    assert_equal 1.5, review.rating
  end

  test "should not update review for a review that i did not create" do
    sign_in users(:esteban12)
    review = reviews(:one_review)

    patch review_url(review), params: { review: { rating: 3.5 } }
    assert_response :forbidden
  end

  test "should update not update review with invalid rating" do
    sign_in users(:esteban11)
    review = reviews(:one_review)

    patch review_url(review), params: { review: { rating: 500.5 } }

    assert_response :unprocessable_entity
  end

    # tests related to show
  test "should get show review" do
    sign_in users(:esteban12)
    review = reviews(:one_review)
    get review_url(review), params: { id: review.id }
    # Assertion for checking show.html.erb view
    assert_response :success
    assert_select 'h3', review.title
  end
end
