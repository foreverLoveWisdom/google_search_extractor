# frozen_string_literal: true

class KeywordScrapingJob < ApplicationJob
  queue_as :default

  def perform(user_id, keywords)
    KeywordScrapingHandlerService.new(user_id, keywords).call
  end
end
