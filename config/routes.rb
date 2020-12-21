Rails.application.routes.draw do

  root 'movies#index'

  resources :movies do
    resources :reviews
    resources :favorites, only: [:create, :destroy]
  end

  get 'movies/filter/:filter', to: 'movies#index', as: 'filtered_movies'

  resources :users
  get 'signup', to: 'users#new'

  resource :session, only: [:new, :create, :destroy]
  get 'signin', to: 'sessions#new'

  resources :genres

end
