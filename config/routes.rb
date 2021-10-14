Rails.application.routes.draw do
  devise_for :professionals, path: 'professionals', controllers: { registrations: "registrations" }
  devise_for :users, path: 'users'
  root to: "home#index"

  resources :occupation_areas, only: [:show]
  resources :profiles, only: [:show, :new, :create, :edit, :update, :index]
  resources :projects, only: [:new, :create, :show, :index] do
    get 'my_projects', on: :collection
    resources :project_applications, only: [:create, :index], shallow: :true do
      post 'accept', on: :member
      post 'reject', on: :member
    end

  end
  get 'my_applications', to: 'project_applications#my_applications'
end
