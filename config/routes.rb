Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'

  get 'sign_up', to: 'users#new', as: 'sign_up'
  get 'log_in', to: 'sessions#new', as: 'log_in'
  get 'log_out', to: 'sessions#destroy', as: 'log_out'

  resources :users
  resources :sessions

  resources :projects, only: [:index, :show] do
    resources :titles
  end

  resources :titles, only: [] do
    resources :todos
  end

  resources :todos, only: [] do
    resources :tomatoes, only: [:create]
  end

end
