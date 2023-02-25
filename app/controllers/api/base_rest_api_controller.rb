# frozen_string_literal: true

module Api
  # Base class for all REST API controllers
  class BaseRestApiController < ActionController::API
    include JsonApiConcern
  end
end
