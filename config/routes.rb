Rails.application.routes.draw do
  # get 'enrollments/index'
  post 'users/new2' => 'users#create_student'
  get 'users/new2' => 'users#new2'
  post 'users/new' => 'users#create'
  get 'courses/new2' => 'courses#new2'
  resources :users, except: :show
  post 'enrollments/new' => 'enrollments#create'
  resources :enrollments
  get 'sessions/new'
  get 'session/new'
  get 'home/index'
  resources :courses do
    member do
      get :select
      get :quit
      get :open
      get :close
    end
    collection do
      get :list
    end
  end
  root 'home#index'
  get 'sessions/login' => 'sessions#new'
  post 'sessions/login' => 'sessions#create'
  delete 'sessions/logout' => 'sessions#destroy'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
