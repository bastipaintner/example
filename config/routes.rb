Rails.application.routes.draw do
  get 'event/index'

  # Leitwarten Routes:
  root 'control_pages#index'
  # resources :control_pages, path: '/zug'
  get '/zug/:id'                    =>  'control_pages#show'
  get '/zug/:id/:time'              =>  'control_pages#show'
  get '/zug/:id/:time/:p_or_n'      =>  'control_pages#show'

  # Allgemeine Routes:
  get     'help'                    =>  'static_pages#help'
  get     'about'                   =>  'static_pages#about'

  # Login Routes:
  get     'login'                   =>  'sessions#new'
  post    'login'                   =>  'sessions#create'
  delete  'logout'                  =>  'sessions#destroy'

  # Administrative Routes:
  get     'administration'          =>  'static_pages#administration'
  resources :trains, :users, :traintypes
  get     'logs/:app'               =>  'logfiles#show'
  get     'logs/:app/:type'         =>  'logfiles#show'

  # Lifebilder Routes:
  post    'upload'                  =>  'images#create'
  get     'images/:id/:num/:time'   =>  'images#show'




  # get     'test'                =>  'static_pages#test'
end
