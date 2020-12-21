Rails.application.routes.draw do
  root to: 'homes#index'
  get '/about' => 'homes#index'
  get '/contact' => 'homes#index'
  namespace :api, format: 'json' do
    resources :tasks, only: %i[index create update]
  end
end
