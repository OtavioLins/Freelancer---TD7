require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :professionals, path: 'professionals', controllers: { registrations: 'registrations' }
  devise_for :users, path: 'users'
  root to: 'home#index'

  mount Sidekiq::Web => '/sidekiq'
  
  resources :occupation_areas, only: [:show]
  resources :professionals, only: [] do
    get 'feedbacks_received_by_users', on: :member
  end
  resources :profiles, only: %i[show new create edit update index]
  resources :projects, only: %i[new create show index] do
    get 'search', on: :collection
    get 'my_projects', on: :collection
    get 'early_closing', on: :member
    get 'team', on: :member
    get 'finishing_confirmation', on: :member
    patch 'finish', on: :member
    patch 'closing', on: :member
    resources :professionals do
      resources :user_feedbacks, only: %i[create new], shallow: true
    end
    resources :project_applications, only: %i[create index], shallow: true do
      post 'accept', on: :member
      patch 'reject', on: :member
      get 'reject_justification', on: :member
      patch 'cancel', on: :member
      get 'cancelation_justification', on: :member
    end
  end
  get 'my_applications', to: 'project_applications#my_applications'
  
  namespace :api do
    namespace :v1 do
      resources :projects, only: %i[index]
      resources :api_clients, only: %i[create]
      post '/login', to: "api_clients#login"
      get '/auto_login', to: "api_clients#auto_login"
    end
  end
end
