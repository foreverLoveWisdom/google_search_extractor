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
FactoryBot.define do
  factory :search_result do
    keyword { nil }
    adwords_advertisers { rand(100) }
    total_links { rand(100) }
    total_search_results do
      "About #{rand(1..9)},000,000 results (#{Faker::Number.between(from: 0.009, to: 0.001).round(3)} seconds)"
    end
    html do
      "<html><head><title>#{Faker::Lorem.word}</title></head><body><h1>#{Faker::Lorem.sentence}</h1></body></html>"
    end
  end
end
