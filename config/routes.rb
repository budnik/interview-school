Rails.application.routes.draw do
  post 'current_user', to: 'sessions#current_user', as: :current_user

  resources :teachers do
    resources :teacher_subjects, shallow: true
  end
  resource :schedule, only: :show
  post 'section/:id', to: 'sections#create', as: :join_section
  resources :subjects
  root to: 'subjects#index'
end
