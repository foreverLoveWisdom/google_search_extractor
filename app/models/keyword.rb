# frozen_string_literal: true

# == Schema Information
#
# Table name: keywords
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  status     :integer          default("pending")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_keywords_on_name     (name)
#  index_keywords_on_status   (status)
#  index_keywords_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Keyword < ApplicationRecord
  validates :name, presence: true

  belongs_to :user
  has_one :search_result, dependent: :destroy

  enum status: { pending: 3, processing: 2, success: 1, fail: 0 }
end
