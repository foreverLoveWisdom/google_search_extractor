# frozen_string_literal: true

# == Schema Information
#
# Table name: search_results
#
#  id                   :bigint           not null, primary key
#  adwords_advertisers  :integer
#  html                 :string           not null
#  total_links          :integer          not null
#  total_search_results :string           not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  keyword_id           :bigint           not null
#
# Indexes
#
#  index_search_results_on_keyword_id  (keyword_id)
#
# Foreign Keys
#
#  fk_rails_...  (keyword_id => keywords.id)
#
class SearchResult < ApplicationRecord
  validates :html, presence: true
  validates :total_links, presence: true
  validates :total_search_results, presence: true

  belongs_to :keyword
end
