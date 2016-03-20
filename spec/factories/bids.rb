FactoryGirl.define do
  factory :bid do
    description { Faker::Lorem.sentence }
    amount { rand(1..999) }
    user
    gig
  end
end
