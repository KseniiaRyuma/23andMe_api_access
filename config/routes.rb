Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # map.root :controller => "home", :action => "index"
  root :to => "home#index"
  # resources :code_response do get "code_response" end
  get '/receive_code', to: 'get_response#get_token'

  get 'get_response/data_process', to: 'get_response#data_process'
end
