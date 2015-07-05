Rails.application.routes.draw do
  resources :achievements, except: :show do
    collection do
      get :manage
    end
  end
  resources :games, except: :show
  resources :players, except: :new
  root "leaderboard#show"
  get "jack-in" => "sessions#new", as: :login
  post "jack-in" => "sessions#create", as: :do_login
  get "jack-out" => "sessions#destroy", as: :logout
  get "manage_league" => "league#edit", as: :edit_league
  patch "manage_league" => "league#update", as: :update_league
end
