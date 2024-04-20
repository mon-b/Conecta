Rails.application.routes.draw do
  get 'home/index'
  devise_for :users
  #get 'hello_world/index'

  root to: "home#index"
  devise_scope :user do
    get 'users/sign_out' => 'devise/sessions#destroy'
  end
  
  # health status (remove)
  #get "up" => "rails/health#show", as: :rails_health_check
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  
  # Defines the root path route ("/")
  # root "articles#index"
end
