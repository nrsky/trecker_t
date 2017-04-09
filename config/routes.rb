Rails.application.routes.draw do

  resources :records, only: [:create]
end


