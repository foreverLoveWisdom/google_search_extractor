# frozen_string_literal: true

# == Schema Information
#
# Table name: search_results
#
#  id                   :bigint           not null, primary key
#  adwords_advertisers  :integer
#  html                 :string
#  total_links          :integer
#  total_search_results :string
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
  belongs_to :keyword
end
