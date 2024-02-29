# config/routes.rb
Rails.application.routes.draw do
  
  root "pages#home"

  get 'announcements', to: 'announcements#index', as: 'announcements'
  get 'announcements/new', to: 'announcements#new', as: 'new_announcement'
  get 'announcements/:id', to: 'announcements#show', as: 'announcement'
  post 'announcements', to: 'announcements#create'
  get 'announcements/:id/edit', to: 'announcements#edit', as: 'edit_announcement'
  patch 'announcements/:id', to: 'announcements#update', as: 'update_announcement'
  delete 'announcements/:id', to: 'announcements#destroy', as: 'delete_announcement'

  get 'attendances', to: 'attendances#index', as: 'attendances'
  get 'attendances/new', to: 'attendances#new', as: 'new_attendance'
  get 'attendances/:id', to: 'attendances#show', as: 'attendance'
  post 'attendances', to: 'attendances#create'
  get 'attendances/:id/edit', to: 'attendances#edit', as: 'edit_attendance'
  patch 'attendances/:id', to: 'attendances#update', as: 'update_attendance'
  delete 'attendances/:id', to: 'attendances#destroy', as: 'delete_attendance'

  resources :events

  get 'members', to: 'members#index', as: 'members'
  get 'members/new', to: 'members#new', as: 'new_member'
  post 'members', to: 'members#create', as: 'create_member'
  get 'members/:id/edit', to: 'members#edit', as: 'edit_member'
  patch 'members/:id', to: 'members#update', as: 'update_member'
  get 'members/:id/delete', to: 'members#delete', as: 'confirm_delete_member'
  delete 'members/:id', to: 'members#destroy', as: 'delete_member'
  get 'members/:id', to: 'members#show', as: 'member'

  resources :members do
    resources :concerns, only: [:index, :new, :create, :edit, :update, :destroy] do
      get 'sort_by_title', on: :collection
      get 'sort_by_time', on: :collection
      get 'sort_by_status', on: :collection
    end
  end
  
  

  devise_for :members, controllers: { omniauth_callbacks: 'members/omniauth_callbacks' }
  devise_scope :member do
    get 'members/sign_in', to: 'members/sessions#new', as: :new_member_session
    delete 'members/sign_out', to: 'members/sessions#destroy', as: :destroy_member_session
  end
end
