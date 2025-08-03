Rails.application.routes.draw do
  mount Rswag::Api::Engine => '/api-docs'
  mount Rswag::Ui::Engine => '/api-docs'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  post 'accounts/signup', to: 'accounts#create'
  scope :accounts do
    scope :login do
      post 'user_login', to: 'logins#create'
      get "refresh-token", to: 'logins#refresh'
    end
  end
  get 'dashboard', to: 'dashboard#index'

  # resources :accounts, only: [:create]
  # resources :logins, only: [:create] do
  #   collection do
  #     get :refresh
  #   end
  # end
  # get :dashboard, to: 'dashboard#index'
end
