FactoryGirl.define do
  factory :gig do
    name { Faker::Lorem.sentence }
    description { Faker::Lorem.sentence }
    budget { rand(1..999) }
    location { "Denver" }
    category
    user
  end
end
