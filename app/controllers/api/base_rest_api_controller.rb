# frozen_string_literal: true

module Api
  # Base class for all REST API controllers
  class BaseRestApiController < ActionController::API
    before_action :authenticate_user!

    include JsonApiConcern

    protected

    def authenticate_user!
      if user_signed_in?
        super
      else
        render_json_api_error_response(error_msg: I18n.t('api.errors.authentication_required'),
                                       status: :unauthorized)
      end
    end
  end
end
