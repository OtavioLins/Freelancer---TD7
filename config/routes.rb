Rails.application.routes.draw do
  devise_for :professionals, path: 'professionals', controllers: { registrations: "registrations" }
  devise_for :users, path: 'users'
  root to: "home#index"

  resources :occupation_areas, only: [:show]
  resources :profiles, only: [:show, :new, :create, :edit, :update, :index]
  resources :projects, only: [:new, :create, :show, :index] do
    get 'my_projects', on: :collection
  end
end
