# Clase que se encarga de manejar los mensajes
class MessagesController < ApplicationController

  # autentificacion de usuario
  before_action :authenticate_user!

  # mostrar todos los mensajes
  # @return [void]
  def create
    @message = Message.new(message_params)
    # things to check. the user id must be the same.
    # the user has to be in the group
    if current_user.id != @message.user_id
      render json: {error: "Cannot create message from a different user"}, status: :forbidden
      return
    end

    if @message.save
      # GroupChannel.broadcast_to(Group.find(@message.group_id), @message)
      render json: @message, status: :created, location: @message
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  private

  # parametros permitidos
  # @return [ActionController::Parameters]
  def message_params
    params.require(:message).permit(:content, :user_id, :group_id)
  end
end
