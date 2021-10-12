Rails.application.routes.draw do
  namespace :api do
    resources :people do
      resources :friendships
    end
  end
end
