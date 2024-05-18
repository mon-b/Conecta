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
end
