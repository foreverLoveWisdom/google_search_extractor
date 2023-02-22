# frozen_string_literal: true

# Background job for scraping keywords
class KeywordScrapingJob < ApplicationJob
  queue_as :default

  def perform(user_id:,
              keyword_file_key:,
              dependencies: { storage_service: ActiveStorage::Blob,
                              keyword_file_parser_service: KeywordFileParserService,
                              keyword_scraping_handler_service: KeywordScrapingHandlerService })
    keyword_file = dependencies[:storage_service].find_by(key: keyword_file_key)
    return if keyword_file.blank?

    file_parser_service = parse_keywords(keyword_file, dependencies[:keyword_file_parser_service])

    if file_parser_service.success?
      execute_scraping_handler_service(user_id,
                                       file_parser_service.result,
                                       dependencies[:keyword_scraping_handler_service])
    else
      log_errors file_parser_service.errors.full_messages.to_sentence
    end
  end

  private

  def parse_keywords(keyword_file, file_parser_service)
    file_parser_service.new(keyword_file).call
  end

  def execute_scraping_handler_service(user_id, keywords, scraping_handler_service)
    scraping_handler_service.new(user_id:, keywords:).call
  end

  def log_errors(error)
    Rails.logger.error error
  end
end
