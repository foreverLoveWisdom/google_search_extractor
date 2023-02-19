# frozen_string_literal: true

# Handling Keywords routing logic
class KeywordsController < ApplicationController
  before_action :authenticate_user!

  def new; end

  def create
    if can_attach_keyword_file?
      redirect_to root_path, notice: I18n.t('keywords.upload_csv_successfully')
    else
      redirect_to root_path, alert: I18n.t('keywords.upload_csv_failed')
    end
  end

  private

  def can_attach_keyword_file?
    keyword_params.present? && current_user.keyword_file.attach(keyword_params)
  end

  def keyword_params
    params.permit(:keyword_file)[:keyword_file]
  end
end
