Rails.application.routes.draw do
  root "home#show"
  get "up" => "rails/health#show", as: :rails_health_check

  get "home" => "home#show"

  scope :articles do
    get "env_switch" => "articles#env_switch"
    get "camera_access" => "articles#camera_access"
    get "test_1" => "articles#test_1"
    get "test_2" => "articles#test_2"
    get "test_3" => "articles#test_3"
    get "test_4" => "articles#test_4"
  end

  get "pop_until", to: "mobile_app/navigation#pop_until", as: :pop_until

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
