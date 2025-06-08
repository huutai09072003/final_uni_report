Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  get "stations/index"
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
    }, skip: [:sessions, :registrations]
  
  devise_for :bloggers, controllers: {
    sessions: 'bloggers/sessions',
    registrations: 'bloggers/registrations'
    }, default: { format: :json }, skip: [:sessions, :registrations]

  devise_scope :blogger do
    get '/bloggers/sign_in', to: 'bloggers/sessions#create', as: :new_blogger_session
    post '/bloggers/sign_in', to: 'bloggers/sessions#create', as: :blogger_session
    delete '/bloggers/sign_out', to: 'bloggers/sessions#destroy', as: :destroy_blogger_session
    get '/bloggers/sign_up', to: 'auth#register', as: :new_blogger_registration
    post '/bloggers', to: 'bloggers/registrations#create', as: :blogger_registration
  end

  devise_scope :user do
    get '/users/sign_in', to: 'users/sessions#create', as: :new_user_session
    post '/users/sign_in', to: 'users/sessions#create', as: :user_session
    delete '/users/sign_out', to: 'users/sessions#destroy', as: :destroy_user_session
    get '/users/sign_up', to: 'auth#register', as: :new_user_registration
    post '/users', to: 'users/registrations#create', as: :user_registration
  end

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq' # Truy cập tại localhost:3000/sidekiq

  resources :posts

  resources :pages, only: [:index]
  resources :sections
  resources :items
  resources :subscribers
  resources :campaigns, only: [:index, :create, :show] do
    member do
      post :donate
      get :donation
      post :verify_donation
      get :all_donations
    end
  end

  resources :donations, only: [:create, :index] do
    collection do
      get 'success'
    end
  end

  resources :wastes do
    collection do
      get 'identify'
    end
  end

  post 'stripe_accounts', to: 'stripe_accounts#create_account'
  post 'stripe_accounts/link', to: 'stripe_accounts#create_account_link'

  resource :user, only: [:show, :edit, :update]

  resource :auth, only: [] do
    collection do
      get 'login'
      get 'register'
    end
  end

  resources :blogs, only: [:index, :create, :show] do
    member do
      post :like
    end
    collection do
      get :top_bloggers
      get :top_views
    end
    resources :comments, only: [:index, :create, :update, :destroy]
  end

  resources :bloggers, only: [:index, :show, :update]

  resources :notifications, only: [:index, :update]
  resources :results, only: [:index, :create]

  resources :images, only: [:index, :show]
  resources :games, only: [:index, :show] do
    member do
      post :upload_image
      post :upload_image_from_url
      get :images
    end
  end

  get 'inertia-example', to: 'inertia_example#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "pages#index"

  resources :stations, only: [:index] do
    collection do
      post "login", to: "stations#login"
    end
  end
end
