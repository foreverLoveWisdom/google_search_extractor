# frozen_string_literal: true

class KeywordRepository
  def initialize(model = Keyword)
    @model = model
  end

  delegate :create!, to: :model
  delegate :update!, to: :model

  private

  attr_reader :model
end
