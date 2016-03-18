FactoryGirl.define do
  factory :user do
    before(:create) {|user| user.skip_confirmation! }
    username { Faker::Internet.user_name(3..20) }
    email { Faker::Internet.email(3..20) }
    password { "password" }
    firstname { Faker::Name.first_name }
    lastname { Faker::Name.last_name }
    description { Faker::Lorem.paragraph }
    location { "Denver" }
    searchable { true }

    trait :with_review do
      after :create do |user|
        user.reviews.create!(rating: 5, reviewer: 1, gig_id: 1, comment: "Test comment")
      end
    end
  end
end
