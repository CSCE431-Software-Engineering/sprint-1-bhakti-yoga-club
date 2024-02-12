# config/routes.rb
Rails.application.routes.draw do
  get 'announcements', to: 'announcements#index'
  get 'announcements/new', to: 'announcements#new', as: 'new_announcement'
  get 'announcements/:id', to: 'announcements#show', as: 'announcement'
  post 'announcements', to: 'announcements#create'

  get 'members', to: 'members#index'
  get 'members/new', to: 'members#new', as: 'new_member'
  post 'members', to: 'members#create'
  get 'members/:id/edit', to: 'members#edit', as: 'edit_member'
  patch 'members/:id', to: 'members#update', as: 'update_member'
  get 'members/:id/delete', to: 'members#delete', as: 'confirm_delete_member'
  delete 'members/:id', to: 'members#destroy', as: 'delete_member'

  
  root "pages#home"
end
