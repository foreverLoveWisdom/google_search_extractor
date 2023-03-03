# frozen_string_literal: true

require 'csv'

# Keyword file parser service
class FileKeywordHandlerService
  prepend SimpleCommand
  include ActiveModel::Validations

  validates :file, :user, presence: true

  def initialize(user:, file:,
                 dependencies: { file_validation_service: KeywordFileValidationService,
                                 keyword_repository: KeywordRepository.new })
    @file = file
    @user = user
    @file_validation_service = dependencies[:file_validation_service]
    @keyword_repository = dependencies[:keyword_repository]
    @keywords = []
    @persisted_keyword_ids = []
  end

  def call
    return unless valid?

    file_validation = file_validation_service.new(user, file).call

    if file_validation.success?
      parse_keywords
      save_keywords
    else
      errors.add(:base, file_validation.errors.full_messages.to_sentence)
    end

    @persisted_keyword_ids
  end

  private

  attr_reader :user,
              :file,
              :file_validation_service,
              :keyword_repository

  def parse_keywords
    CSV.parse(user.keyword_file.blob.download, **csv_options) do |row|
      keyword = row[:keywords]
      keyword = CGI.escapeHTML(keyword) if keyword.present?
      @keywords << keyword if keyword.present?
    end
  end

  def csv_options
    { headers: true,
      header_converters: :symbol,
      skip_blanks: true,
      quote_char: '"',
      force_quotes: true }
  end

  def save_keywords
    @keywords.each do |keyword|
      @persisted_keyword_ids << keyword_repository.create(keyword_params(user.id, keyword))
                                                  .id
    end
  end

  def keyword_params(user_id, keyword)
    { user_id:, name: keyword }
  end
end
