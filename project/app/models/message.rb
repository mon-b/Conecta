class Message < ApplicationRecord
  belongs_to :user
  belongs_to :group

  after_create_commit { broadcast_message }

  private

  def broadcast_message
    # ActionCable.server.broadcast([:channel], {
    #   id: id,
    #   content: content
    # })
    # Broadcastea el mensaje en si mismo al grupo
    GroupChannel.broadcast_to(Group.find(self.group_id), self) # send to the correct group channel the data of the current object
  end
end
