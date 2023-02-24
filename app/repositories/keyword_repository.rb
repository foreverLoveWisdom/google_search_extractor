# frozen_string_literal: true

# Decouple the Keyword data access layer from the rest of the application
class KeywordRepository
  delegate :create!, to: :model
  delegate :update!, to: :model
  delegate :find_by, to: :model

  def initialize(model = Keyword)
    @model = model
  end

  def search(keyword, user_id)
    return if keyword.blank? || user_id.blank?

    model.includes(:search_result)
         .where(user_id:)
         .where('keywords.name ILIKE ?', "%#{keyword}%")
         .order(name: :asc)
  end

  def find_all_by_user(user_id)
    model.where(user_id:).order(name: :asc)
  end

  private

  attr_reader :model
end
