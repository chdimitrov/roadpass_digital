FactoryBot.define do
  factory :trip do
    sequence(:name) { |n| "Trip #{n} - #{Faker::Address.city} #{Faker::House.room}" }
    image_url { "https://example.com/trip-#{Faker::Number.unique.number(digits: 5)}.jpg" }
    short_description { Faker::Lorem.sentence(word_count: 8) }
    long_description { Faker::Lorem.paragraph(sentence_count: 2) }
    rating { rand(1..5) }
  end
end





