class ChatChannel < ApplicationCable::Channel
  def subscribed
     stream_from "chat_#{params[:group_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def send_message(data)
    Message.create!(content:data['message'], group_id: data['group_id'], user_id: data['user_id'])
  end

end