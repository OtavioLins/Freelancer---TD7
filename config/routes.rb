Rails.application.routes.draw do
  devise_for :professionals, path: 'professionals'
  devise_for :users, path: 'users'
  root to: "home#index"

  resources :profiles, only: [:show, :new, :create, :update]
end
