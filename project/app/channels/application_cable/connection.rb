module ApplicationCable
  # Connection class for ActionCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    # Metodo que se encarga de conectar al usuario
    # @return [void]
    def connect
      self.current_user = find_verified_user
      logger.add_tags 'ActionCable', current_user.name
    end

    protected
    # Metodo que se encarga de verificar al usuario
    # @return [User] el usuario verificado
    def find_verified_user
      # if verified_user = User.find_by(id: cookies.encrypted[:user_id])
      if (verified_user = env['warden'].user)
        verified_user
      else
        reject_unauthorized_connection
      end
    end
  end
end
