FactoryBot.define do
  factory :trip do
    sequence(:name) { |n| "Trip #{n} - #{Faker::Address.city} #{Faker::House.suffix}" }
    image_url { "https://example.com/trip-#{Faker::Number.unique.number(digits: 5)}.jpg" }
    short_description { Faker::Lorem.sentence(word_count: 10) }
    long_description { Faker::Lorem.paragraphs(number: 3).join("\n\n") }
    rating { rand(1..5) }
  end
end




