Rails.application.routes.draw do

  get 'users/new'

  devise_for :users

  resources :collaborators

  resources :wikis do
    resources :collaborators, only: [:new, :create, :destroy]
  end

  get 'welcome/index'

  get 'welcome/about'

  root 'welcome#index'

  resources :charges, only: [:new, :create, :destroy]


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
