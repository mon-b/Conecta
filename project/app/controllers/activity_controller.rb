class ActivityController < ApplicationController
  def index
  end

  def show
    @activity = Activity.find(params[:id])
  end

  def new
    if !user_signed_in?
      redirect_to '/users/sign_in'
    end
  end

  def new_activity
    # @activity = Activity.new(group_id: params[:group_id],
    #                 name: params[:name],
    #                 pictures: params[:pictures],
    #                 location: params[:location],
    #                 date: params[:date],
    #                 description: params[:description],
    #                 picture: params[:picture],
    #                 keywords: params[:keywords],
    #                 cost: params[:cost],
    #                 people: params[:people])
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
