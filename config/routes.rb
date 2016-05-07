################################################################################
# routing form outside in                                                      #
#                                                                              #
# author: Sebastian Paintner                                                   #
#                                                                              #
# path: config/routes.rb                                                       #
################################################################################
Rails.application.routes.draw do
  # leitwarten routes:
  root 'control_pages#index'
  get '/zug/:id'                    =>  'control_pages#show'
  get '/zug/:id/:time'              =>  'control_pages#show'
  get '/zug/:id/:time/:p_or_n'      =>  'control_pages#show'

  # general routes:
  get     'help'                    =>  'static_pages#help'
  get     'about'                   =>  'static_pages#about'

  # login routes:
  get     'login'                   =>  'sessions#new'
  post    'login'                   =>  'sessions#create'
  delete  'logout'                  =>  'sessions#destroy'

  # administrative routes:
  get     'administration'          =>  'static_pages#administration'
  get     'logs/:app'               =>  'logfiles#show'
  get     'logs/:app/:type'         =>  'logfiles#show'
  resources :trains, :users, :traintypes

  # images routes:
  post    'upload'                  =>  'images#create'
  get     'images/:id/:num/:time'   =>  'images#show'
end
