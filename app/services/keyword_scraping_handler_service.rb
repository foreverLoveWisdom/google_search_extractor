# frozen_string_literal: true

# Keywords scraping handler service logic
class KeywordScrapingHandlerService
  prepend SimpleCommand
  include ActiveModel::Validations

  validates :user_id, presence: true
  validates :keywords, presence: true

  def initialize(user_id:, keywords:,
                 dependencies: { scraping_service: KeywordScrapingService,
                                 keyword_repository: KeywordRepository.new,
                                 search_result_repository: SearchResultRepository.new })
    @user_id = user_id
    @keywords = keywords
    @scraping_service = dependencies[:scraping_service]
    @keyword_repository = dependencies[:keyword_repository]
    @search_result_repository = dependencies[:search_result_repository]
    @created_search_result_ids = []
  end

  def call
    return unless valid?

    keywords.each do |keyword|
      @scraper = create_keyword_and_execute_scraper(keyword)
      process_scraping_result(keyword)
    rescue ActiveRecord::RecordInvalid => e
      handle_exception_for(e)
      next
    end

    created_search_result_ids
  end

  private

  attr_reader :user_id,
              :keywords,
              :scrapping_service,
              :keyword_repository,
              :search_result_repository,
              :created_search_result_ids

  def create_keyword_and_execute_scraper(keyword)
    @persisted_keyword = create_keyword!(keyword)
    KeywordScrapingService.call(keyword)
  end

  def create_keyword!(keyword)
    keyword_repository.create!(user_id:, name: keyword)
  end

  def process_scraping_result(keyword)
    if @scraper.success?
      handle_scraping_success
    else
      handle_scraping_failure(keyword)
    end
  end

  def handle_scraping_success
    update_keyword_status!(Keyword.statuses[:success])
    persisted_search_result = create_search_result!
    created_search_result_ids << persisted_search_result.id
  end

  def handle_scraping_failure(keyword)
    update_keyword_status!(Keyword.statuses[:fail])
    errors.add(:base, I18n.t('keyword_scraping_handler_service.errors.scraper_failed', keyword:))
  end

  def handle_exception_for(exception)
    log_error_and_backtrace(exception)
    errors.add(:base, I18n.t('keyword_scraping_handler_service.errors.record_invalid'))
  end

  def log_error_and_backtrace(exception)
    Rails.logger.error exception.message
    Rails.logger.error exception.backtrace.inspect
  end

  def update_keyword_status!(status)
    keyword_repository.update!(@persisted_keyword.id, status:)
  end

  def create_search_result!
    search_result_repository.create!({ keyword_id: @persisted_keyword.id }.merge(@scraper.result))
  end
end
