Rails.application.routes.draw do

  devise_for :users

  resources :gigs, param: :uid do
    post :update_status
    resources :bids
    post :finish
    collection do
      get :search_all
    end
  end

  resources :users, param: :uid, only: [:show] do
    resources :reviews, only: [:new, :create, :show]
    resources :conversations do
      resources :messages, only: [:create]
    end
    collection do
      get :search_all
    end
  end

  get '/dashboard'  => 'users#dashboard'
  get '/about_us'   => 'pages#about_us'
  get '/howitworks' => 'pages#howitworks'
  
  post '/gigs/:gig_uid/bids/:bid_id/select_bid'   => 'gigs#select_bid',   as: :select_bid
  post '/gigs/:gig_uid/bids/:bid_id/deselect_bid' => 'gigs#deselect_bid', as: :deselect_bid
  post '/users/update_searchable' => 'users#update_searchable', as: :update_searchable
  post '/user/:user_uid/messages' => 'messages#new_message', as: :user_messages
  delete '/image/:imageable_id' => 'images#destroy', as: :image_destroy

  root 'gigs#index'
end
