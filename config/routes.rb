Rails.application.routes.draw do
  root "leaderboard#show"
  get "jack-in" => "sessions#new", as: :login
  get "jack-out" => "sessions#destroy", as: :logout
  resources :sessions, only: [:new, :create]
end
