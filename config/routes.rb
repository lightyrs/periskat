Rails.application.routes.draw do

  resources :meerkats
  resources :periscopes
  resources :broadcasters

  root 'home#index'
end
