# frozen_string_literal: true

# Handling Search routing logic
class SearchController < ApplicationController
  def index
    @keywords = KeywordRepository.new.search(params[:keyword], current_user.id)
  end
end
