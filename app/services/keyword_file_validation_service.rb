# frozen_string_literal: true

require 'csv'

# Keyword file validation service
class KeywordFileValidationService
  prepend SimpleCommand
  include ActiveModel::Validations

  MIN_KEYWORDS = 1
  MAX_KEYWORDS = 100

  validates :file, presence: true

  def initialize(user, file)
    @current_user = user
    @file = file
  end

  def call
    return unless valid?
    return unless can_attach_file?
    return unless valid_number_of_keywords?
  end

  private

  attr_reader :current_user, :file

  def valid_number_of_keywords?
    number_of_keywords = CSV.read(file_path, headers: true).count

    if number_of_keywords < MIN_KEYWORDS
      errors.add(:base, I18n.t('keywords.errors.min_keywords', min_keywords: MIN_KEYWORDS))

      return false
    elsif number_of_keywords > MAX_KEYWORDS
      errors.add(:base, I18n.t('keywords.errors.max_keywords', max_keywords: MAX_KEYWORDS))

      return false
    end

    true
  end

  def can_attach_file?
    if current_user.keyword_file.attach(file)
      true
    else
      errors.add(:base, I18n.t('keywords.errors.attach_file_failed'))
      false
    end
  end

  def file_path
    file.path
  end
end
