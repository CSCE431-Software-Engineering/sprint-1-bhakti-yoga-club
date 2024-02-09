# config/routes.rb
Rails.application.routes.draw do
  resources :announcements

  root "pages#home"
end
