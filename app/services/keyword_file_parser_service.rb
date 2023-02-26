# frozen_string_literal: true

require 'csv'

# Keyword file parser service
class KeywordFileParserService
  prepend SimpleCommand
  include ActiveModel::Validations

  validates :file, presence: true

  MIN_KEYWORDS = 1
  MAX_KEYWORDS = 100

  def initialize(file)
    @file = file
    @keywords = []
  end

  def call
    return unless valid?

    CSV.parse(file.download, **csv_options) do |row|
      keyword = row[:keywords]
      keyword = CGI.escapeHTML(keyword) if keyword.present?
      @keywords << keyword if keyword.present?

      break if @keywords.count > 100
    end

    validate_number_of_keywords
    keywords
  end

  private

  attr_reader :file, :keywords

  def csv_options
    { headers: true,
      header_converters: :symbol,
      skip_blanks: true,
      quote_char: '"',
      force_quotes: true }
  end

  def validate_number_of_keywords
    return if @keywords.count.between?(1, 100)

    errors.add(:base, I18n.t('keyword_file_parser_service.errors.invalid_number_of_keywords'))
  end
end
