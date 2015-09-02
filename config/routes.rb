Rails.application.routes.draw do
  post "search", to: "search#new"
  post 'init_call', to: 'search#init_call'
  post 'handle_response', to: 'search#handle_response'
  post 'status_callback', to: 'search#status_callback'

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end
