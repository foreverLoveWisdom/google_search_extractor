# frozen_string_literal: true

# Background job for scraping keyword
class KeywordScrapingJob < ApplicationJob
  def perform(keyword_id)
    KeywordScrapingHandlerService.call(keyword_id:)
  end
end
