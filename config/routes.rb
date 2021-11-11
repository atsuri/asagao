Rails.application.routes.draw do
  root "top#index"
  get "about" => "top#about", as: "about"
  get "bad_request" => "top#bad_request"
  get "forbidden" => "top#forbidden"
  get "internal_server_error" => "top#internal_server_error"

  1.upto(20) do |n|
    get "lesson/step#{n}(/:name)" => "lesson#step#{n}"
  end

  resources :members do 
    get "search", on: :collection
    resources :entries, only: [:index]
  end

  resource :session, only: [:create, :destroy]
  resource :account, only: [:show, :edit, :update]
  resource :password, olny: [:show, :edit, :update]

  resources :articles
  resources :entries
  resources :duties, only: [:index]
end
