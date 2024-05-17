class Message < ApplicationRecord
  belongs_to :user
  belongs_to :group

  after_create_commit { broadcast_message }

  private

  def broadcast_message
    ActionCable.server.broadcast([:channel], {
      id: id,
      content: content
    })
  end
end
