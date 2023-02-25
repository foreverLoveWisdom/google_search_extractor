# frozen_string_literal: true

# Handling sessions routing logic
module Api
  module V1
    # Handling API V1 sessions routing logic
    class SessionsController < BaseRestApiController
      def create
        user = User.find_by(email: params[:email])

        if user&.valid_password?(params[:password])
          render_jsonapi user
        else
          render_json_api_error_response(error_msg: 'Invalid email or password')
        end
      end
    end
  end
end
