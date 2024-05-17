class GroupsController < ApplicationController

  before_action :authenticate_user!

  def my_groups
    @groups = current_user.groups
    render :my_groups
  end

  def show
    @group = Group.find(params[:id])
  end

  def new
  end


  def new_post
    # def create
    @group = Group.new(group_params)

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
    if !is_group_admin
      render html: helpers.tag.h1('No autorizado'), status: :forbidden
      return
    end
      render :edit
  end

  def update
    @group = Group.find(params[:id])
    if !is_group_admin
      render html: helpers.tag.h1('No autorizado'), status: :forbidden
      return
    end

    if @group.update(group_params)
      redirect_to @group
    else
      # mostrar errores aqui
      render :edit, status: :unprocessable_entity
    end
  end

  def group_params
    params.require(:group).permit(:category_id, :user_id, :name, :description, :profile_picture, :rating)
  end

  def is_group_admin
    current_user.id == @group.user_id
  end
  helper_method :is_group_admin
end
