class ApplicationController < ActionController::Base
  # Code from https://github.com/heartcombo/devise?tab=readme-ov-file#configuring-views
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :birth_date, :profile_picture])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :birth_date, :profile_picture])
  end
end
