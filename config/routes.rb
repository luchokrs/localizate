Rails.application.routes.draw do
  resources :stores
  resources :users

  get "/webhook", to: "webhook#verify"
  post "/webhook", to: "webhook#receive_message"

  get "up" => "rails/health#show", as: :rails_health_check
end