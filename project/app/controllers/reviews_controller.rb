class ReviewsController < ApplicationController

  def new
  end
  def create
    # Find the activity
    @activity = Activity.find(params[:activity_id])
    @review = @activity.reviews.new(review_params)
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
    params.require(:review).permit(:rating, :body, :activity_id)
  end
  end
