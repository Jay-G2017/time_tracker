Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'
  mount Main => '/'

  get 'sign_up', to: 'users#new', as: 'sign_up'
  get 'log_in', to: 'sessions#new', as: 'log_in'
  get 'log_out', to: 'sessions#destroy', as: 'log_out'
  get 'time_tracker', to: 'projects#first_load'
  get 'today_tomatoes', to: 'tomatoes#today_tomatoes'

  resources :users
  resources :sessions

  resources :projects, only: [:show, :edit, :update, :destroy] do
    resources :titles
    member do
      patch 'star'
      patch 'unstar'
      patch 'done'
      patch 'undone'
    end
  end

  resources :titles, only: [] do
    resources :todos, except: [:update]
  end

  resources :todos, only: [:update] do
    resources :tomatoes, only: [:create]
    member do
      get 'tomatoes_timeline'
    end
  end

  resources :categories do
    resources :projects, only: [:index, :new, :create]
  end

end
