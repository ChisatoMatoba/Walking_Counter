Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'

  get '/slack/index', to: 'slack#index'
  post 'slack/fetch_thread_from_url', to: 'slack#fetch_thread_from_url'
end
