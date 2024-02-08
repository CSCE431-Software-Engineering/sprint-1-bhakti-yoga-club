# config/routes.rb
Rails.application.routes.draw do
  get 'announcements', to: 'announcements#index'
  get 'announcements/new', to: 'announcements#new', as: 'new_announcement'
  post 'announcements', to: 'announcements#create'
  get 'announcements/:id', to: 'announcements#show', as: 'announcement'
  
  root "pages#home"
end
