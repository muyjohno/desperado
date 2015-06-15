Rails.application.routes.draw do
  root "leaderboard#show"
  get "login" => "sessions#new", as: :login
  get "logout" => "sessions#destroy", as: :logout
  resources :sessions, only: [:new, :create]
end
