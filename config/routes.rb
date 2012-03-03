require 'resque/server'

Snappyblog::Application.routes.draw do
  root to: 'articles#index'

  resources :articles, only: [:index, :new, :create, :show]

  mount Resque::Server.new, at: '/resque'
end
