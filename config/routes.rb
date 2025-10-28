Rails.application.routes.draw do
  root "addresses#index"

  # routes
  resources :addresses, only: %i[index create]

  # utility
  get "up" => "rails/health#show", as: :rails_health_check
end
