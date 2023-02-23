# frozen_string_literal: true

# == Schema Information
#
# Table name: keywords
#
#  id         :bigint           not null, primary key
#  name       :string
#  status     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_keywords_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Keyword < ApplicationRecord
  belongs_to :user
  has_one :search_result, dependent: :destroy

  enum status: { processing: 2, success: 1, fail: 0 }
end
