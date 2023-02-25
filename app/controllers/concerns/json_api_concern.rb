# frozen_string_literal: true

# JSON API specification concern
module JsonApiConcern
  extend ActiveSupport::Concern

  included do
    include JSONAPI::Errors
    include JSONAPI::Fetching
    include JSONAPI::Pagination
    include JSONAPI::Deserialization
  end

  def render_jsonapi(data)
    render jsonapi: data
  end

  def render_json_api_error_response(error_msg:, status: :unprocessable_entity)
    error = {
      detail: error_msg
    }

    render json: { errors: [error] }, status:
  end
end
