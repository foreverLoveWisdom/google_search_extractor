# frozen_string_literal: true

class KeywordsController < ApplicationController
  before_action :authenticate_user!

  def new; end

  def create
    current_user.keyword_file.attach(params[:keyword_file])
    redirect_to root_path
  end
end
