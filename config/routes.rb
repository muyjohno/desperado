Rails.application.routes.draw do
  resources :games, except: :show
  resources :players, except: [:show, :new]
  root "leaderboard#show"
  get "jack-in" => "sessions#new", as: :login
  post "jack-in" => "sessions#create", as: :do_login
  get "jack-out" => "sessions#destroy", as: :logout
end
