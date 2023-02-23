# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protected

  def authenticate_user!
    if user_signed_in?
      super
    else
      redirect_to new_user_registration_path, notice: 'You need to sign up before continuing.'
    end
  end
end
