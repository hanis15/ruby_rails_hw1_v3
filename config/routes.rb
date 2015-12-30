Rails.application.routes.draw do
  resources :posts
  resources :tag_strings
  get '/posts/filter/:id' => 'posts#filter', as: "post_filter"
  root to: 'posts#index'
end
