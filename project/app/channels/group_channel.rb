class GroupChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    # Broadcastea lo que sea que reciba hacia el grupo
    group = Group.find(params[:id])
    stream_for group
    # !!! el stream_for se asocia al modelo del grupo! asi se identifica altiro
    # https://api.rubyonrails.org/classes/ActionCable/Channel/Streams.html
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
