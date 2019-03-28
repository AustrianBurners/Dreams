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
    get 'get_flag_states', on: :member
    post 'join', on: :member
    post 'archive', on: :member
    post 'create_flag_event', on: :member
    patch 'toggle_favorite', on: :member
    patch 'toggle_granting', on: :member
    patch 'update_grants', on: :member
    post 'remove_tag', on: :member
    post 'tag', on: :member
  end

  get '/pages/:page' => 'pages#show'
  get '/me' => 'users#me'
  get '/howcanihelp' => 'howcanihelp#index'
  
  get '*unmatched_route' => 'application#not_found'
end