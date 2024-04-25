class GroupsController < ApplicationController
  def index
  end

  def show
    @group = Group.find(params[:id])
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
    if @group.save
      @group.users << current_user
      redirect_to @group
    else
      flash[:errors] = @group.errors.full_messages
      redirect_to '/new', locals: { group: @group }
    end
  end

  def edit
  end

  def group_params
    params.require(:group).permit(:category_id, :name, :description, :user_id)
  end
  # def group_params
  #   params.require(:group).permit(:category_id, :name, :user_id, :description)
  # end
end
