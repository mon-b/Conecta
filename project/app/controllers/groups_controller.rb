class GroupsController < ApplicationController

  def my_groups
    @groups = current_user.groups
    render :my_groups
  end

  def show
    @group = Group.find(params[:id])
    @activities = @group.activities.order(date: :desc).limit(6)
  end

  def new
    if !user_signed_in?
      redirect_to '/users/sign_in'
    end
    # if user_signed_in?
    #   @group = Group.new
    # else
    #   redirect_to '/users/sign_in'
    # end
  end


  def new_post
    # def create
    @group = Group.new(category_id: params[:category_id],
                       name: params[:name],
                       user_id: params[:user_id],
                       description: params[:description])

    if params[:profile_picture].present?
      @group.profile_picture.attach(params[:profile_picture])
    end

    if @group.save
      @group.users << current_user
      redirect_to @group
    else
      flash[:errors] = @group.errors.full_messages
      redirect_to '/new', locals: { group: @group }
    end
  end



  def index
    @groups = Group.all
    render :index
  end

  def edit
    @group = Group.find(params[:id])
    render :edit
  end

  def update
    @group = Group.find(params[:id])

    if @group.update(group_params)
      redirect_to @group
    else
      # mostrar errores aqui
      render :edit, status: :unprocessable_entity
    end
  end

  def group_params
    params.require(:group).permit(:category_id, :name, :description, :user_id)
  end

  def is_group_admin
    if current_user.id == @group.user_id
      return true
    else
      return false
    end
  end
  helper_method :is_group_admin
end
