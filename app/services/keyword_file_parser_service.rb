# frozen_string_literal: true

require 'csv'

# Keyword file parser service
class KeywordFileParserService
  prepend SimpleCommand
  include ActiveModel::Validations

  validates :file, presence: true

  def initialize(file)
    @file = file
    @keywords = []
  end

  def call
    return unless valid?

    CSV.parse(file.download, **csv_options) do |row|
      keyword = row[:keywords]
      keywords << CGI.escapeHTML(keyword) if keyword.present?
    end

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
end
