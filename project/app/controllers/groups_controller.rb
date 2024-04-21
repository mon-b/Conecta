class GroupsController < ApplicationController
  def index
  end

  def show
    @group = Group.find(params[:id])
  end

  def new
    if user_signed_in?
      # @group = Group.new()
    else
      redirect_to '/users/sign_in'
    end


  end


  def new_post
    @group = Group.new(category_id: params[:category_id],
                   name: params[:name],
                   user_id: params[:user_id],
                   description: params[:description])
    @group.save
    redirect_to @group
  end

  def edit
  end

  # def group_params
  #   params.require(:group).permit(:category_id, :name, :user_id, :description)
  # end
end
