# Clase que se encarga de manejar la comunicación en tiempo real entre los usuarios de un grupo
class GroupChannel < ApplicationCable::Channel

  # Método que se encarga de suscribir al usuario a un grupo
  # @return [void]
  def subscribed
    # probando
    # Broadcastea lo que sea que reciba hacia el grupo
    group = Group.find(params[:id])
    # checkea q el usuario sea del grupo
    # https://api.rubyonrails.org/classes/ActionCable/Channel/Base.html
    reject unless group.users.include?(current_user)
    stream_for group
    # !!! el stream_for se asocia al modelo del grupo! asi se identifica altiro
    # https://api.rubyonrails.org/classes/ActionCable/Channel/Streams.html
  end

  # Método que se encarga de desuscribir al usuario de un grupo
  # @return [void]
  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
