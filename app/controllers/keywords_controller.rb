# frozen_string_literal: true

# Handling Keywords routing logic
class KeywordsController < ApplicationController
  before_action :authenticate_user!

  def new; end

  def create
    current_user.keyword.attach(params[:keyword])
    redirect_to root_path, notice: I18n.t('keywords.upload_csv_successfully')
  end
end
