class RequestController < ApplicationController
  def index
    if user_signed_in?
      @requests = Request.where(user_id: current_user.id)
    else
      redirect_to '/users/sign_in'
    end
  end

  def show
    if user_signed_in?
      @request = Request.find(params[:id])
      if (current_user.id != @request.user_id) && (current_user.id != Group.find(@request.group_id).user_id)
        render html: helpers.tag.h1('No autorizado'), status: :forbidden
      end
    else
      redirect_to '/users/sign_in'
    end
  end

  def new
    if !user_signed_in?
      redirect_to '/users/sign_in'
    end
  end

  def new_request
    exist = Request.find_by(group_id: params[:group_id], user_id: params[:user_id])
    if exist
      flash[:errors] = ['Ya tienes una solicitud pendiente para este grupo']
      redirect_to '/new'
    else

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
  end

  def edit
  end

  def destroy
    @request = Request.find(params[:id])
    @request.destroy
    redirect_to '/request'
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
