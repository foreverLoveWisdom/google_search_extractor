# frozen_string_literal: true

FactoryBot.define do
  factory :search_result do
    keyword { nil }
    adwords_advertisers { 1 }
    total_links { 1 }
    total_search_results { 'MyString' }
    html { 'MyString' }
  end
end
