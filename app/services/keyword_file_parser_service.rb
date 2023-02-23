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

    CSV.parse(file.download, headers: true) do |row|
      keyword = row['Keywords']
      keywords << keyword if keyword.present?
    end

    keywords
  end

  private

  attr_reader :file, :keywords
end
