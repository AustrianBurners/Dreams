Rails.application.routes.draw do
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end

  post "/graphql", to: "graphql#execute"
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
  root 'camps#index'
  
  devise_for :users,
    controllers: { 
      omniauth_callbacks: 'users/omniauth_callbacks',
      registrations: 'users/registrations' 
  }
  
  resources :camps, :path => 'dreams' do
    resources :images
    resources :safety_sketches
    post 'join', on: :member
    post 'archive', on: :member
    patch 'toggle_granting', on: :member
    patch 'update_grants', on: :member
    patch 'tag', on: :member
  end

  get '/pages/:page' => 'pages#show'
  get '/me' => 'users#me'
  get '/howcanihelp' => 'howcanihelp#index'
  
  get '*unmatched_route' => 'application#not_found'
end