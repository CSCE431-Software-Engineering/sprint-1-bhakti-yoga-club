Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  # config/routes.rb
  Rails.application.routes.draw do
    get 'announcements/make_announcement', to: 'announcements#new', as: 'new_announcement'
    root 'pages#home'
  end


end
