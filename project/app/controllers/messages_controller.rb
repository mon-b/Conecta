class MessagesController < ApplicationController
  before_action :authenticate_user!
  def create
    @message = Message.new(message_params)
    # things to check. the user id must be the same.
    # the user has to be in the group
    if current_user.id != @message.user_id
      render json: {error: "Cannot create message from a different user"}, status: :forbidden
      return
    end

    if @message.save
      render json: @message, status: :created, location: @message
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  private
  def message_params
    params.require(:message).permit(:content, :user_id, :group_id)
  end
end
