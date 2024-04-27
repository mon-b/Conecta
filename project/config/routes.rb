Rails.application.routes.draw do
  #get 'activity/index'
  #get 'activity/show'
  #get 'activity/new'
  #get 'activity/edit'
  resources :activity, except: [:new, :create]
  get 'groups/:group_id/new_activity', to: 'activity#new'
  post 'activity', to: 'activity#new_activity'
  # get 'groups/index'
  # get 'groups/show'
  # get 'groups/new'
  # get 'groups/edit'
  resources :groups
  post 'groups/new', to: 'groups#new_post'
  post 'activity/new', to: 'activity#new_activity'
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
