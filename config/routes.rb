Rails.application.routes.draw do
  devise_for :users
  # mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # get 'profiles/sponsorship'
  root to: 'pages#home'
  get 'my_profile', to: 'profiles#show', as: :my_profile

  # get 'community', to: 'posts#index', as: :community
  resources :courses, only: [:index, :show] do
    resources :posts, only: [:create]
  end
  resources :posts, only: [:index, :create, :destroy] do
    resources :upvotes, only: :create
    resources :emojis, only: [:create, :destroy]
    resources :comments, only: [:create, :destroy]
  end
  resources :participations, only: [] do
    collection do
      get :past_participations
      get :upcoming_participations
      get :favorites
    end
    member do
      patch :add_in_favorite
    end
  end
  resources :invitations, only: [:create]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
