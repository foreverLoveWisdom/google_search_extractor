# frozen_string_literal: true

class SearchResultRepository
  def initialize(model = SearchResult)
    @model = model
  end

  delegate :create!, to: :model

  attr_reader :model
end
