class RequestController < ApplicationController
  def index
  end

  def show
  end

  def new
    if !user_signed_in?
      redirect_to '/users/sign_in'
    end
  end

  def new_request
    @request = Request.new(group_id: params[:group_id],
                    user_id: params[:user_id],
                    status: params[:status],
                    description: params[:description],)
    if @request.save
      redirect_to @request
    else
      flash[:errors] = @request.errors.full_messages
      redirect_to '/new', locals: { request: @request }
    end
  end

  def edit
  end

  # Metodo para saber si desplegar o no boton de Solicitud
  def is_group_admin
    if current_user.id == @group.user_id
      return true
    else
      return false
    end
  end
  helper_method :is_group_admin
end
