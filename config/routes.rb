Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'

  get '/fetch_thread', to: 'slack#fetch_thread'

end
