class ActivityController < ApplicationController

  before_action :authenticate_user!

  def index
  end

  def show
    @activity = Activity.find(params[:id])
  end

  def new
    # new activity view
  end

  def new_activity
    @activity = Activity.new(activity_params)
    if @activity.save
      redirect_to @activity
    else
      flash[:errors] = @activity.errors.full_messages
      redirect_to '/new', locals: { activity: @activity }
    end
  end

  def edit
  end

  private
  def activity_params
    params.require(:activity).permit(:group_id, :name, :location, :date, :description, :picture, :keywords, :cost,
                                     :people , pictures: [])
  end

  def is_group_member
    @group = Group.find(@activity.group_id)
    @group.users.include?(current_user)
  end

  def activity_has_reviews?
    @activity.reviews.any?
  end

  def date_has_passed?
    @activity.date < Time.now
  end

  helper_method [:is_group_member, :activity_has_reviews?, :date_has_passed?]
end
