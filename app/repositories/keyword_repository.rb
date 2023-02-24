# frozen_string_literal: true

# Decouple the Keyword data access layer from the rest of the application
class KeywordRepository
  delegate :create!, to: :model
  delegate :update!, to: :model

  def initialize(model = Keyword)
    @model = model
  end

  def search(keyword, user_id)
    return if keyword.blank? || user_id.blank?

    Keyword.includes(:search_result)
           .where(user_id:)
           .where('keywords.name ILIKE ?', "%#{keyword}%")
  end

  private

  attr_reader :model
end
