# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'home#index'
  devise_for :users
  resources :clock_logs, only: %i[index show create update destroy]
end
