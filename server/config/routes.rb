Rails.application.routes.draw do
  root "home#show"
  get "up" => "rails/health#show", as: :rails_health_check

  get "home" => "home#show"

  namespace :api, defaults: {format: :json} do
    namespace :mobile do
      namespace :v1 do
        namespace :android do
          resource :path_configuration, only: :show
        end
        namespace :ios do
          resource :path_configuration, only: :show
        end
      end
    end
  end
end
