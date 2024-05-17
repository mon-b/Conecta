class MessagesController < ApplicationController
  before_action :authenticate_user!
  def create
    current_user
    @message = current_user.messages.new(messages_params)

    if @message.save
      render json: @message, status: :created, location: @message
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end
end
