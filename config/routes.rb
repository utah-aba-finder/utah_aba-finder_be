Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }

  namespace :api do
    namespace :v1 do
      resources :providers, only: [:index, :show, :update]
      resources :states, only: [:index] do
        resources :counties, only: [:index]
        resources :providers, only: [:index], action: :index, controller: '/api/v1/states/providers'
      end
      resources :insurances, only: [:index]


      namespace :admin do
        resources :providers, only: [:index, :show, :update, :create]
        # resources :users, only: [:index, :show, :update, :create]
        resources :insurances, only: [:create, :update, :destroy]
      end
      post '/payments/create_payment_intent', to: 'payments#create_payment_intent'
    end
  end
end

