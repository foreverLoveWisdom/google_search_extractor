# frozen_string_literal: true

# Decouple the SearchResult data access layer from the rest of the application
class SearchResultRepository
  delegate :create!, to: :model
  delegate :find_by, to: :model

  def initialize(model = SearchResult)
    @model = model
  end

  private

  attr_reader :model
end
