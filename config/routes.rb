Rails.application.routes.draw do

  #NOTE create record and see index creating in ElasticSearch, should be changed,see Record model
  resources :records, only: [:create]
  resources :fields, only: [:create]
  resources :drivers, only: [:create]
  resources :companies, only: [:create]


  #TODO resources drivers, companies, fields, only: [:create, :update, :delete]
  get :processed_time_by_activities, controller:"application"
end


