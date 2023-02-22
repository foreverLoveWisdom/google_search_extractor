# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password(min_length: 6) }

    trait :with_keywords do
      transient do
        keywords_file { Rails.root.join('spec/fixtures/files/keywords.csv') }
      end

      after(:build) do |user, evaluator|
        user.keyword_file.attach(
          io: evaluator.keywords_file.open,
          filename: File.basename(evaluator.keywords_file),
          content_type: 'text/csv'
        )
      end
    end
  end
end
