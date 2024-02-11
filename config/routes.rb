# config/routes.rb
Rails.application.routes.draw do
  get 'announcements', to: 'announcements#index'
  get 'announcements/new', to: 'announcements#new', as: 'new_announcement'
  get 'announcements/:id', to: 'announcements#show', as: 'announcement'
  post 'announcements', to: 'announcements#create'

  get 'members', to: 'members#index'
  get 'members/new', to: 'members#new', as: 'new_member'
  post 'members', to: 'members#create'

  
  root "pages#home"
end
