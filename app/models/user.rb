# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                              :bigint           not null, primary key
#  authentication_token            :text
#  authentication_token_created_at :datetime
#  email                           :string           default(""), not null
#  encrypted_password              :string           default(""), not null
#  remember_created_at             :datetime
#  reset_password_sent_at          :datetime
#  reset_password_token            :string
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#
# Indexes
#
#  index_users_on_authentication_token  (authentication_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         :rememberable,
         :validatable,
         :token_authenticatable

  has_one_attached :keyword_file
  validates :keyword_file, content_type: 'text/csv'
  validate :validate_keyword_count
  # temporarily disable validate_keyword_count callback
  skip_callback :validate, :before, :validate_keyword_count, if: :skip_validate_keyword_count?

  has_many :keywords, dependent: :destroy

  private

  def skip_validate_keyword_count?
    true
  end

  # TODO: Investigate why the 'validate_keyword_count' method is throwing an ActiveStorage::FileNotFoundError.
  # This error may occur if the file attached to the 'keyword_file' attribute cannot be found in the storage location.
  # Verify that the storage service is correctly configured and the file exists in the expected location.
  def validate_keyword_count
    if keyword_file.attached?
      keywords = keyword_file.download.split(/\r?\n/)

      if keywords.length > MAX_KEYWORDS
        errors.add(:keyword_file, "must contain at most #{KeywordFileParserService::MAX_KEYWORDS} keywords")
      elsif keywords.empty?
        errors.add(:keyword_file, 'must contain at least 1 keyword')
      end
    else
      errors.add(:keyword_file, 'must be attached')
    end
  end
end
