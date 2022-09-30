Rails.application.routes.draw do
  get 'relationships/followings'
  get 'relationships/followers'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users
  root to:"homes#top"
  get "home/about"=>"homes#about"

  resources :books, only: [:index,:show,:edit,:create,:destroy,:update]do
    resource:favorites,only: [:create,:destroy]
    resource:post_comments,only:[:create,:destroy]
   end
  resources :users, only: [:index,:show,:edit,:update]do
    resource :relationships, only: [:create,:destroy]
    get :followings, on: :member
    get :followers, on: :member
   end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

end