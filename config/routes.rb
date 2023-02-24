# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  authenticated :user do
    resources :keywords, only: %i[index show new create]
    get 'search', to: 'search#index'
  end

  unauthenticated do
    get '*path' => redirect('/users/sign_in')
  end

  root to: 'keywords#new'
end
