# frozen_string_literal: true

# Keywords scraping handler service logic
class KeywordScrapingHandlerService
  prepend SimpleCommand
  include ActiveModel::Validations

  validates :keyword_id, presence: true

  def initialize(keyword_id:,
                 dependencies: { scraping_service: KeywordScrapingService,
                                 keyword_repository: KeywordRepository.new,
                                 search_result_repository: SearchResultRepository.new })
    @keyword_id = keyword_id
    @scraping_service = dependencies[:scraping_service]
    @keyword_repository = dependencies[:keyword_repository]
    @search_result_repository = dependencies[:search_result_repository]
  end

  def call
    return unless valid?

    begin
      keyword = find_keyword_and_update_status
      return if errors.any?

      @scraper = execute_scraper(keyword.name)
      scraper_result_handler
    rescue ActiveRecord::RecordInvalid => e
      handle_exception_for(e)
    end
  end

  private

  attr_reader :keyword_id,
              :scrapping_service,
              :keyword_repository,
              :search_result_repository

  def find_keyword_and_update_status
    keyword = keyword_repository.find_by(id: keyword_id)
    return unless keyword_present?(keyword)
    return unless keyword_pending?(keyword)

    keyword_repository.update!(keyword_id, status: :processing)
    keyword
  end

  def keyword_present?(keyword)
    if keyword.present?
      true
    else
      errors.add(:base, 'Keyword not found')
      false
    end
  end

  def keyword_pending?(keyword)
    if keyword.pending?
      true
    else
      errors.add(:base, 'Keyword status is not pending')
      false
    end
  end

  def scraper_result_handler
    if @scraper.success?
      scraper_success_handler
    else
      scraper_failure_handler
    end
  end

  def scraper_success_handler
    keyword_repository.update!(keyword_id, status: :success)
    create_search_result!
  end

  def scraper_failure_handler
    keyword_repository.update!(keyword_id, status: :fail)
    errors.add(:base, @scraper.errors.full_messages.to_sentence)
  end

  def execute_scraper(keyword)
    KeywordScrapingService.call(keyword)
  end

  def handle_exception_for(exception)
    log_error_and_backtrace(exception)
    errors.add(:base, I18n.t('keyword_scraping_handler_service.errors.record_invalid'))
  end

  def log_error_and_backtrace(exception)
    Rails.logger.error exception.message
    Rails.logger.error exception.backtrace.inspect
  end

  def create_search_result!
    search_result_repository.create!(search_result_params)
  end

  def search_result_params
    { keyword_id: }.merge(@scraper.result)
  end
end
