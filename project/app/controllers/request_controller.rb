class RequestController < ApplicationController

  before_action :authenticate_user!

  def index
    @requests = Request.where(user_id: current_user.id)
  end

  def show
    @request = Request.find(params[:id])
    if (current_user.id != @request.user_id) && (current_user.id != Group.find(@request.group_id).user_id)
      render html: helpers.tag.h1('No autorizado'), status: :forbidden
    end
  end

  def new
    # new request view
  end

  def new_request
    exist = Request.find_by(group_id: params[:group_id], user_id: params[:user_id])
    # WIP: añadir validacion de que el usuario no sea ya de ese grupo
    group = Group.find(params[:group_id])
    user = User.find(params[:user_id])
    if group.user_id == current_user.id
      flash[:danger] = ['Eres admin de este grupo, no te puedes unir']
      redirect_to '/new'
      return
    end
    if group.users.include?(user)
      flash[:danger] = ['El usuario ya es miembro de este grupo']
      redirect_to '/new'
      return
    end
    if exist
      flash[:danger] = ['Ya tienes una solicitud pendiente para este grupo']
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


  def update
  # Esta ruta permite aceptar una request
    @request = Request.find(params[:id])
  @group = @request.group
  if current_user.id != @group.user_id
    head :forbidden
    return
  end
  # solo se pueden editar peticiones pendientes y no se puede cambiar el estado al mismo
  # falta filtrar que solo puede ser pending, accepted o rejected
  if @request.status != "pending" || @request.status == params[:status]
    # head :bad_request
    flash[:danger] = ['No puedes editar una request aceptada/denegada']
    redirect_to request_index_path
    return
  end

    @request.status = params[:status]
    if @request.save
      if params[:status] == "accepted"
        @group.users << User.find(@request.user_id)
      end
      flash[:success] = ['Aceptaste una request correctamente']
      redirect_to request_index_path
      # head :ok
    else
      head :unprocessable_entity
    end
  end

  def edit
  end

  def destroy
    @request = Request.find(params[:id])
    if @request.status == "pending"
      @request.destroy
      head :ok
    else
      flash[:warning] = ['No puedes destruir una request aceptada/denegada']
      redirect_to request_index_path
      # head :bad_request
    end
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
