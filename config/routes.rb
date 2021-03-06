Rails.application.routes.draw do
  root to: 'products#index'


  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :products do
    resources :product_negotiations
  end



  resources :singlebids


  resources :productnegotiations do
    resources :singlebids
  end

  resources :users do
    resources :products do
      get :toggle_accept_offer
    end
  end

end
