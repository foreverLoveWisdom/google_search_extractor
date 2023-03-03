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
    file_handler_service = handle_file_keyword

    if file_handler_service.success?
      queue_keyword_scraping_jobs(file_handler_service.result)
      redirect_to keywords_path, notice: I18n.t('keywords.upload_csv_successfully')
    else
      redirect_to root_path, alert: file_handler_service.errors.full_messages.to_sentence
    end
  end

  private

  def keyword_params
    params.permit(:keyword_file)[:keyword_file]
  end

  def keyword_repository
    @keyword_repository ||= KeywordRepository.new
  end

  def handle_file_keyword
    FileKeywordHandlerService.call(user: current_user, file: keyword_params)
  end

  # NOTE: Extract to a separate service if logic gets more complex
  def queue_keyword_scraping_jobs(keyword_ids)
    keyword_ids.each do |keyword_id|
      KeywordScrapingJob.perform_later(keyword_id)
    end
  end
end
