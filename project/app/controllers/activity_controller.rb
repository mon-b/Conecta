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
    @activity = Activity.find(params[:id])
    @group = Group.find(@activity.group_id)
    if !is_group_admin_activity?
      render html: helpers.tag.h1('No autorizado'), status: :forbidden
      return
    end

      render :edit
  end

  def update
    @activity = Activity.find(params[:id])
    @group = Group.find(@activity.group_id)
    if !is_group_admin_activity?
      render html: helpers.tag.h1('No autorizado'), status: :forbidden
      return
    end

    if @activity.update(activity_params)
      redirect_to @activity
    else
      # mostrar errores aqui
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @activity = Activity.find(params[:activity_id])
    if !is_group_admin_activity?
      render html: helpers.tag.h1('No autorizado'), status: :forbidden
      return
    end
    @activity.destroy
    redirect_to '/activity'
  end

  private
  def activity_params
    params.require(:activity).permit(:group_id, :name, :location, :date, :description, :picture, :keywords, :cost,
                                     :people , pictures: [])
  end

  def is_group_member?(activity)
    group = Group.find(activity.group_id)
    group.users.include?(current_user)
  end

  def activity_has_reviews?
    @activity.reviews.any?
  end

  def date_has_passed?
    @activity.date < Time.now
  end

  def is_group_admin_activity?(activity)
    id_group = activity.group_id
    current_user.id == Group.find(id_group).user_id
  end

  helper_method [:is_group_member?, :activity_has_reviews?, :date_has_passed?, :is_group_admin_activity?]
end
