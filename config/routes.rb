Rails.application.routes.draw do

  resources :tasks 
  devise_for :users

  authenticated :user do
    root 'users#index'
  end

  unauthenticated :user do
    devise_scope :user do
      get "/" => "devise/sessions#new"
    end
  end

  resources :conversations do
    resources :messages
  end


  get '/list' =>'users#list'
  get '/search' =>'users#search'
  get '/new' =>'users#new'
  post '/create' =>'users#create'
  get '/accueil' =>'users#accueil'
  post '/tasks/create' => 'tasks#create'
  post '/tasks/create' => 'tasks#create'
  
  mount Maktoub::Engine => '/'

end
