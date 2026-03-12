require "sidekiq/web"

Rails.application.routes.draw do
  # This should not be accesible in production without authentication,
  # but for the sake of this exercise, we'll leave it open.
  mount Sidekiq::Web => "/sidekiq"

  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      resources :trips, only: %i[index show create]
    end
  end
end
