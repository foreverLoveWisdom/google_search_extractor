# frozen_string_literal: true

# Create some users
10.times do
  User.create!(
    email: Faker::Internet.email,
    password: 'password',
    authentication_token: Devise.friendly_token,
    authentication_token_created_at: Time.zone.now
  )
end

def generate_html_source_code
  "<html><head><title>#{Faker::Lorem.word}</title></head><body><h1>#{Faker::Lorem.sentence}</h1></body></html>"
end

def generate_total_search_results
  number = rand(1..9)
  "About #{number},000,000 results (#{Faker::Number.between(from: 0.009, to: 0.001).round(3)} seconds)"
end

# Create some keywords for each user
User.all.each do |user|
  3.times do
    keyword = user.keywords.create!(
      name: Faker::Lorem.word,
      status: Keyword.statuses[:success]
    )

    # Create a search result for each keyword
    keyword.create_search_result!(
      adwords_advertisers: rand(100),
      html: generate_html_source_code,
      total_links: rand(100),
      total_search_results: generate_total_search_results
    )
  end
end
