Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'

  resources :slacks do

    member do
      post :reload_thread
    end
  end
end
