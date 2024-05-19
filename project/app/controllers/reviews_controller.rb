class ReviewsController < ApplicationController

  def new
  end
  def create
    # Find the activity
    @activity = Activity.find(params["review"][:activity_id])

    # if the user is not a member of the group associated to the activity, it is not allowed to give a review
    if !@activity.group.users.include?(current_user)
      head :forbidden
      return
    end
    @review = @activity.reviews.new(review_params)
    @review.user = current_user
    if @review.save
      redirect_to @activity
    else
      flash[:errors] = @review.errors.full_messages
      redirect_back_or_to '/'
    end
  end

  def show
    @review = Review.find(params[:id])
  end


  private
  def review_params
    params.require(:review).permit(:title, :rating, :body, :activity_id)
  end
end
