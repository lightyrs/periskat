Rails.application.routes.draw do

  resources :meerkats
  resources :broadcasters

  root 'home#index'
end
