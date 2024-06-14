# Modelos de los mensajes
class Message < ApplicationRecord
  # Asociacion: Un mensaje pertenece a un usuario y a un grupo
  belongs_to :user
  belongs_to :group

  after_create_commit { broadcast_message }

  private

  # Metodo que se encarga de enviar el mensaje a todos los usuarios del grupo
  # @return [void]
  def broadcast_message
    # ActionCable.server.broadcast([:channel], {
    #   id: id,
    #   content: content
    # })
    # Broadcastea el mensaje en si mismo al grupo
    message_with_username = self.attributes.merge(username_raw: User.find(self.user_id).name)
    GroupChannel.broadcast_to(Group.find(self.group_id), message_with_username)
    # send to the correct group channel the data of the current object
  end
end
