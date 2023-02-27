# frozen_string_literal: true

module Api
  module V1
    # Handling API V1 SearchResults routing logic
    class SearchResultsController < BaseRestApiController
      def show
        search_result = search_result_repository.find_by(keyword_id: params[:id])

        if search_result.blank?
          render_json_api_error_response(error_msg: 'Search result not found', status: :not_found)
        else
          render_jsonapi search_result
        end
      end

      private

      def search_result_repository
        @search_result_repository ||= SearchResultRepository.new
      end
    end
  end
end
