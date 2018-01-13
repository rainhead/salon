Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :messages
  
  get 'ui/index'
  root 'ui#index'
end
