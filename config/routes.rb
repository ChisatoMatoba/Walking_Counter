Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'

  resources :slacks do
    resources :slack_posts do
    end
  end
end
