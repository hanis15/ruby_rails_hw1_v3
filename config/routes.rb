Rails.application.routes.draw do
  resources :posts
  resources :tag_strings
  root to: 'posts#index'
end
