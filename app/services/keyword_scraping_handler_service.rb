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
  end

  def call
    return unless valid?

    created_search_result_ids = []

    keywords.each do |keyword|
      @persisted_keyword = create_keyword!(keyword)
      scraper = KeywordScrapingService.call(keyword)

      if scraper.success?
        update_keyword_status!(Keyword.statuses[:success])
        persisted_search_result = create_search_result!
        created_search_result_ids << persisted_search_result.id
      else
        update_keyword_status!(Keyword.statuses[:fail])
        errors.add(:base, I18n.t('keyword_scraping_handler_service.errors.scraper_failed', keyword:))
      end
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error e.message
      Rails.logger.error e.backtrace.inspect
      errors.add(:base, I18n.t('keyword_scraping_handler_service.errors.record_invalid'))
      next
    end

    created_search_result_ids
  end

  private

  attr_reader :user_id,
              :keywords,
              :scrapping_service,
              :keyword_repository,
              :search_result_repository

  def create_keyword!(keyword)
    keyword_repository.create!(user_id:, keyword:)
  end

  def update_keyword_status!(status)
    keyword_repository.update!(@persisted_keyword.id, status)
  end

  def create_search_result!
    search_result_repository.create!(keyword_id: @persisted_keyword.id)
  end
end
