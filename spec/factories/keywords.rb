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
FactoryBot.define do
  factory :keyword do
    name { Faker::Lorem.word }
    association :user, factory: :user

    trait :processing do
      status { 2 }
    end

    trait :success do
      status { 1 }

      after(:create) do |keyword|
        create(:search_result, keyword:)
      end
    end

    trait :fail do
      status { 0 }
    end
  end
end
