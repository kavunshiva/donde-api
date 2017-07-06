Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users
      resources :devices
      resources :positions
      post '/auth', to: 'auth#create'
      get '/current_device', to: 'auth#show_device'
      get '/current_user', to: 'auth#show_user'
      get '/users/:id/devices', to: 'devices#index'
      get '/devices/:id/positions', to: 'device_positions#index'
    end
  end
end
