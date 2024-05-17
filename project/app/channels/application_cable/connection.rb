module ApplicationCable
  class Connection < ActionCable::Connection::Base
    
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    # Code from: https://stackoverflow.com/questions/42451889/how-do-i-get-current-user-in-actioncable-rails-5-api-app
    def find_verified_user
      verified_user = env['warden'].user
      if verified_user  
        verified_user
      else
        reject_unauthorized_connection
      end

    end
  end
end