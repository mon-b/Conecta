class RequestController < ApplicationController

  # autentificacion de usuario
  before_action :authenticate_user!

  # mostrar todas las solicitudes
  # @return [void]
  def index
    @requests = Request.where(user_id: current_user.id)
  end

  # mostrar una solicitud
  # @return [void]
  def show
    @request = Request.find(params[:id])
    if (current_user.id != @request.user_id) && (current_user.id != Group.find(@request.group_id).user_id)
      render html: helpers.tag.h1('No autorizado'), status: :forbidden
    end
  end

  # crear una nueva solicitud
  # @return [void]
  def new
    # new request view
  end

  # crear una nueva solicitud
  # @return [void]
  def new_request
    begin
      exist = Request.find_by(group_id: params[:group_id], user_id: params[:user_id])
      # WIP: añadir validacion de que el usuario no sea ya de ese grupo
      group = Group.find(params[:group_id])
      user = User.find(params[:user_id])
    rescue ActiveRecord::RecordNotFound
      head :unprocessable_entity
      return
    end

    if group.user_id == current_user.id
      flash[:danger] = ['Eres admin de este grupo, no te puedes unir']
      # redirect_back_or_to ({ action: "new" })
      # redirect_to controller: :request, action: :new
      redirect_to '/'
      return
    end
    if group.users.include?(user)
      flash[:danger] = ['Ya eres miembro de este grupo']
      redirect_back_or_to '/'
      return
    end
    if exist
      flash[:danger] = ['Ya tienes una solicitud pendiente para este grupo']
      redirect_back_or_to '/'
      return
    end
    @request = Request.new(group_id: params[:group_id],
                           user_id: params[:user_id],
                           status: params[:status],
                           description: params[:description],)
    if @request.save
      redirect_to @request
    else
      flash[:errors] = @request.errors.full_messages
      redirect_back_or_to '/', locals: { request: @request }
    end
  end

  # editar una solicitud
  # @return [void]
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

  # eliminar una solicitud
  # @return [void]
  # @raise [ActiveRecord::RecordNotFound] en caso de que no se encuentre la solicitud
  def destroy
    @request = Request.find(params[:id])
  
    if @request.user_id != current_user.id
      head :forbidden
      return
    end
  
    if @request.status == "pending"
      @request.destroy
      flash[:success] = 'Solicitud cancelada exitosamente.'
    else
      flash[:warning] = 'No puedes destruir una solicitud aceptada/denegada'
    end
  
    redirect_to request_index_path
  end
  
  
end
