class MessagesController < ApplicationController

    def create
        @messages = Message.new(message_params)

        if @messages.save
            ActionCable.server.broadcast "chat_#{params[:group_id]}", content: @messages.content, user_id: @messages.user_id
        else
            # Mostrar error
        end
     end

    private
    
    def message_params
        params.require(:message).permit(:content, :group_id, :user_id)
    end

end
