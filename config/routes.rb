Rails.application.routes.draw do
  get 'top/index'

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'top#index'
  resources :projects, shallow: true do
    resources :tasks
  end
  resources :tasks do
    member do
      get :prev_tasks,:next_tasks
    end
  end
  resources :prev_task_relationships, only:[:create,:destroy]
  resources :next_task_relationships, only:[:create,:destroy]
end
