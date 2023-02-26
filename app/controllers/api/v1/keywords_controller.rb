# frozen_string_literal: true

module Api
  module V1
    # Handling API V1 Keywords routing logic
    class KeywordsController < BaseRestApiController
      def index
        render_jsonapi keyword_repository.find_all_by_user(current_user.id)
      end

      def create
        if can_attach_keyword_file?
          KeywordScrapingJob.perform_later(user_id: current_user.id,
                                           keyword_file_key: current_user.keyword_file.key)
          render json: { message: I18n.t('keywords.upload_csv_successfully') }, status: :accepted
        else
          render_json_api_error_response(error_msg: I18n.t('keywords.upload_csv_failed'))
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
  end
end
