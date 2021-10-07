Rails.application.routes.draw do
  devise_for :professionals, path: 'professionals'
  devise_for :users, path: 'users'
  root to: "home#index"
end
