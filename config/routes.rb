Rails.application.routes.draw do
  devise_for :professionals, path: 'professionals', controllers: { registrations: "registrations" }
  devise_for :users, path: 'users'
  root to: "home#index"

  resources :profiles, only: [:show, :new, :create, :update]
end
