class ReviewsController < ApplicationController
    def new_review
      # Find the activity
      @activity = Activity.find(params[:activity_id])
      @review = @activity.reviews.new
      @review.user = current_user
      if @review.save 
        redirect_to '/review/' + @review.id.to_s
      else
        flash[:errors] = @activity.errors.full_messages
        redirect_to @activity
      end
    end
  
    private
  
    def review_params
      params.require(:review).permit(:rating, :body)
    end
  end