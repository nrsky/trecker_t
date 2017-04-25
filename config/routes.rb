Rails.application.routes.draw do
  root "records#index"


  resources :records, only: [:create] do
    collection do
      post :upload
      get  :processed_time_by_activities
    end
  end
  resources :fields, only: [:create]
  resources :drivers, only: [:create, :index, :show]
  resources :companies, only: [:create]
end


