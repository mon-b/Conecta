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
    @activity = Activity.new(group_id: params[:group_id],
                    name: params[:name],
                    location: params[:location],
                    date: params[:date],
                    description: params[:description],
                    picture: params[:picture],
                    keywords: params[:keywords],
                    cost: params[:cost],
                    people: params[:people])
    if @activity.save
      redirect_to @activity
    else
      flash[:errors] = @activity.errors.full_messages
      redirect_to '/new', locals: { activity: @activity }
    end
  end

            
  def activity_params
    params.require(:activity).permit(:group_id, :name, :location, :date, :description, :picture, :keywords, :cost, :people)
  end

  def edit
  end
end
