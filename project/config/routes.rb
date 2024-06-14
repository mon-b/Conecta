Rails.application.routes.draw do
  resources :messages, only: [:create, :show]
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  get 'request/index'
  #get 'request/show'
  #get 'request/new'
  #get 'request/edit'
  get 'groups/mine', to: 'groups#my_groups'
  resources :request, except: [:new, :create]
  get 'groups/:group_id/new_request', to: 'request#new'
  post 'request', to: 'request#new_request'
  #get 'activity/index'
  #get 'activity/show'
  #get 'activity/new'
  #get 'activity/edit'
  resources :activity, except: [:new, :create]
  get 'groups/:group_id/new_activity', to: 'activity#new'
  post 'activity', to: 'activity#new_activity'
  patch 'activity/:activity_id/edit', to: 'activity#update'
  #delete 'activity/:activity_id/destroy', to: 'activity#destroy'
  # get 'groups/index'
  # get 'groups/show'
  # get 'groups/new'
  # get 'groups/edit'
  # resources :groups
  resources :groups do
    get 'messages_json', to: 'groups#show_chat_json'
    get 'chat', to: 'groups#show_chat'
    delete 'destroy_group', to: 'groups#destroy'
  end
  # get 'groups/:group_id/messages_json', to: 'groups#show_chat_json'
  # get 'groups/:group_id/chat', to: 'groups#show_chat'
  post 'groups/new', to: 'groups#new_post'
  post 'activity/new', to: 'activity#new_activity'
  get 'groups/', to: 'groups#index'
  get 'home/index'

  resources :reviews, only: [:create, :show, :edit, :destroy, :update]
  get 'activity/:activity_id/new_review', to: 'reviews#new'
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
  mount ActionCable.server => '/cable'
end
