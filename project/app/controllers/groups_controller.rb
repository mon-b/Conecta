# Controlador de grupos
class GroupsController < ApplicationController

  # Verifica que el usuario este autenticado
  before_action :authenticate_user!

  # muestra los grupos a los que pertenece el usuario
  # @return [Array<Group>] grupos a los que pertenece el usuario
  def my_groups
    @groups = current_user.groups
    render :my_groups
  end

  # muestra las actividades de un grupo
  def show
    @group = Group.find(params[:id])
    @activities = @group.activities.order(date: :desc).limit(4)
  end

  def new
  end

  # Crea un nuevo grupo
  # @return [Group] grupo creado
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



  # Muestra todos los grupos
  # @return [Array<Group>] todos los grupos
  def index
    @categories = Category.all # helping category-based filtering

    if params[:category_id].present?
      @groups = Group.where(category_id: params[:category_id])
    else
      @groups = Group.all
    end
  end

  # modifica un grupo
  # @return [Group] grupo modificado
  def edit
    @group = Group.find(params[:id])
    if !is_group_admin
      render html: helpers.tag.h1('No autorizado'), status: :forbidden
      return
    end
      render :edit
  end

  # Actualiza la modificacion de un grupo
  # @return [Group] grupo modificado
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

  # Muestra los chats de un grupo
  # @return [Array<Message>] mensajes del grupo
  def show_chat_json
    # Returns the messages associated to the group in JSON format
    group = Group.find(params[:group_id])
    if !group.users.include?(current_user)
      render json: {}, status: :forbidden
      return
    end

    # https://stackoverflow.com/q/65112155/5674961
    messages = group.messages.map do |message|
      message.attributes.merge(username_raw: User.find(message.user_id).name)
    end
    render json: messages
    # render json: group.messages#group, include: [:messages]
  end

  # Muestra los chats de un grupo
  # @return [void]
  def show_chat
    group = Group.find(params[:group_id])
    if !group.users.include?(current_user)
      render html: helpers.tag.h1('No estas autorizado para ver los chats de este grupo'), status: :forbidden
      return
    end
  end

  # Elimina un grupo
  # @return [void]
  def destroy
    @group = Group.find(params[:group_id])
    if !is_group_admin
      render html: helpers.tag.h1('No autorizado'), status: :forbidden
      return
    end
    @group.destroy
    redirect_to '/groups'
  end

  private

  # Parametros permitidos para un grupo
  # @return [ActionController::Parameters] parametros del grupo
  def group_params
    params.require(:group).permit(:category_id, :user_id, :name, :description, :profile_picture, :rating)
  end

  # Verifica si el usuario es administrador del grupo
  # @return [Boolean] si el usuario es administrador del grupo
  def is_group_admin
    current_user.id == @group.user_id
  end

  # Verifica si el usuario es miembro del grupo
  # @param [group] group
  def is_group_member(group)
    group.users.include?(current_user)
  end

  # Cuenta los miembros de un grupo
  def member_count(group)
    group.users.count
  end

  helper_method [:is_group_admin, :is_group_member, :member_count]
end
