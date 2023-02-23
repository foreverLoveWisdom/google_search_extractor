# frozen_string_literal: true

# Handling Keywords routing logic
class KeywordsController < ApplicationController
  before_action :authenticate_user!

  def index
    @keywords = current_user.keywords
  end

  def show
    @keyword = current_user.keywords.find(params[:id])
  end

  def new; end

  def create
    if can_attach_keyword_file?
      KeywordScrapingJob.perform_later(current_user.id, current_user.keyword_file.key)
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
