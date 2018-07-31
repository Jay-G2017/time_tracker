Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :projects, only: [:show, :index]
  root 'welcome#index'

  get 'sign_up', to: 'users#new', as: 'sign_up'
  get 'log_in', to: 'sessions#new', as: 'log_in'
  get 'log_out', to: 'sessions#destroy', as: 'log_out'
  resources :users
  resources :sessions
end
