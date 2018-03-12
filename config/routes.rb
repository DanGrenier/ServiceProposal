Rails.application.routes.draw do
  devise_for :users, controllers: {registrations: 'users/registrations'}

  root 'pages#home'
  resources :users
  resources :proposal_settings
  resources :available_services
  resources :proposal_templates
  resources :proposals
  post '/proposal/render' => 'proposals#report'
  get '/proposal/render' => redirect('/proposals')
  get '/pick_template' => 'pick_proposal_templates#index'
  
end
