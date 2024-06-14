# Clase que se encarga de manejar las actividades
class ActivityController < ApplicationController

  # autentificacion de usuario
  before_action :authenticate_user!

  # mostrar todas las actividades
  # @return [void]
  def index
  end

  # mostrar una actividad
  # @return [void]
  # @raise [ActiveRecord::RecordNotFound] en caso de que no se encuentre la actividad
  def show
    @activity = Activity.find(params[:id])
  end

  # crear una nueva actividad
  # @return [void]
  def new
    # new activity view
  end

  # crear una nueva actividad
  # @return [void]
  def new_activity
    @activity = Activity.new(activity_params)
    if @activity.save
      redirect_to @activity
    else
      flash[:errors] = @activity.errors.full_messages
      redirect_to '/new', locals: { activity: @activity }
    end
  end

  # editar una actividad
  # @return [void]
  # @raise [ActiveRecord::RecordNotFound] en caso de que no se encuentre la actividad o grupo
  def edit
    @activity = Activity.find(params[:id])
    @group = Group.find(@activity.group_id)
    if !is_group_admin_activity?
      render html: helpers.tag.h1('No autorizado'), status: :forbidden
      return
    end
      render :edit
  end

  # modificar una actividad
  # @return [void]
  # @raise [ActiveRecord::RecordNotFound] en caso de que no se encuentre la actividad o grupo
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

  # eliminar una actividad
  # @return [void]
  # @raise [ActiveRecord::RecordNotFound] en caso de que no se encuentre la actividad
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

  # parametros de la actividad permitidos
  # @return [ActionController::Parameters] parametros de la actividad
  def activity_params
    params.require(:activity).permit(:group_id, :name, :location, :date, :description, :picture, :keywords, :cost,
                                     :people , pictures: [])
  end

  # verifica si el usuario es administrador del grupo
  # @param [activity] activity
  # @return [Boolean] si el usuario es administrador del grupo
  def is_group_member?(activity)
    group = Group.find(activity.group_id)
    group.users.include?(current_user)
  end

  # verifica si la actividad tiene reviews
  # @return [Boolean] si la actividad tiene reviews
  def activity_has_reviews?
    @activity.reviews.any?
  end

  # verifica si la fecha de la actividad ya paso
  # @return [Boolean] si la fecha de la actividad ya paso
  def date_has_passed?
    @activity.date < Time.now
  end

  # verifica si el usuario es administrador del grupo de la actividad
  # @return [Boolean] si el usuario es administrador del grupo de la actividad
  def is_group_admin_activity?
    id_group = @activity.group_id
    current_user.id == Group.find(id_group).user_id
  end

  # metodos disponibles en la vista
  helper_method [:is_group_member?, :activity_has_reviews?, :date_has_passed?, :is_group_admin_activity?]
end
