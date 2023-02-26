# frozen_string_literal: true

# Handling Keywords routing logic
class KeywordsController < ApplicationController
  def index
    @keywords = keyword_repository.find_all_by_user(current_user.id)
  end

  def show
    @keyword = keyword_repository.find_by(id: params[:id], user_id: current_user.id)
  end

  def new; end

  def create
    if can_attach_keyword_file?
      KeywordScrapingJob.perform_later(user_id: current_user.id, keyword_file_key: current_user.keyword_file.key)
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

  def keyword_repository
    @keyword_repository ||= KeywordRepository.new
  end
end
