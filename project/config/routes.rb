Rails.application.routes.draw do
  devise_for :users
  get 'hello_world/index'

  # health status (remove)
  get "up" => "rails/health#show", as: :rails_health_check
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html


  root "hello_world#index"
  # Defines the root path route ("/")
  # root "articles#index"
end
