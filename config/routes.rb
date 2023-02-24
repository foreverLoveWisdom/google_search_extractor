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
    match '*path' => redirect('/users/sign_in'), via: %i[get post put patch delete]
  end

  root to: 'keywords#new'
end
