Rails.application.routes.draw do
  resources :checkout_sessions
  resource :webhook

  resource :config
  # (same as...) get '/config', to: 'configs#show'
  root 'static_pages#root'
end
