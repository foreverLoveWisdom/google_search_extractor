# frozen_string_literal: true

FactoryBot.define do
  factory :keyword do
    user { nil }
    name { 'MyString' }
    status { 1 }
  end
end
