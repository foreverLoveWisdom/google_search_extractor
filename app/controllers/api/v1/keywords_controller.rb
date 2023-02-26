# frozen_string_literal: true

module Api
  module V1
    # Handling API V1 Keywords routing logic
    class KeywordsController < BaseRestApiController
      def index
        render_jsonapi keyword_repository.find_all_by_user(current_user.id)
      end

      def keyword_repository
        @keyword_repository ||= KeywordRepository.new
      end
    end
  end
end
