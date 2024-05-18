class ReviewsController < ApplicationController
    def index
    end

    def new_review
      # create
      activity = Activity.find(params[:activity_id])
      user = User.find(params[:user_id])
      review = Review.new(review_params)
      review.activity = activity
      review.user = user

      if review.save
        redirect_to @activity
      else
        flash[:errors] = review.errors.full_messages
        redirect_back_or_to '/', locals: { review: review }
      end
  
        
    end

    def review_params
      params.require(:review).permit(:rating, :comment, :user_id, :activity_id)
    end
  end