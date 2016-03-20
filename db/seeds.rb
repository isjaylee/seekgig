# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

bob = User.new(username: "bob", email: "leejay100@gmail.com", password: "password", firstname: "bob", lastname: "green",
                  description: Faker::Lorem.paragraph, location: "55109")
bob.skip_confirmation!
bob.save!

joe = User.new(username: "joe", email: "seekgig@gmail.com", password: "password", firstname: "joe", lastname: "blue",
                  description: Faker::Lorem.paragraph, location: "55414")
joe.skip_confirmation!
joe.save!

LOCATIONS = ["55109", "Twin Cities", "Denver", "Miami", "New York City", "Minneapolis", "San Francisco"]

10.times do
  user = User.new(username: Faker::Internet.user_name, email: Faker::Internet.email, password: "password", firstname: Faker::Name.first_name, lastname: Faker::Name.last_name,
              description: Faker::Lorem.paragraph, location: LOCATIONS.sample)
  user.skip_confirmation!
  user.save!
end

Category.create(name: "Lawn Care")
Category.create(name: "Home Improvement")
Category.create(name: "General Labor")

gig = Gig.create(name: "Test", description: Faker::Lorem.paragraph, budget: rand(1..999), category_id: 1, location: "123 Main Street, Saint Paul, MN 55101", user_id: bob.id)

30.times do
  sleep 0.25
  Gig.create(name: Faker::Lorem.sentence, description: Faker::Lorem.paragraph(2),
             budget: rand(1..999), category_id: rand(1..3), location: LOCATIONS.sample, user_id: rand(1..2))
end

Review.create(comment: Faker::Lorem.sentence(2), rating: 5, reviewer: bob.id, user_id: joe.id, gig_id: gig.id)
Review.create(comment: Faker::Lorem.sentence(2), rating: 3, reviewer: joe.id, user_id: bob.id, gig_id: gig.id)

convo = Conversation.create(sender_id: bob.id, recipient_id: joe.id)
Message.create(subject: Faker::Lorem.sentence, body: Faker::Lorem.paragraph(2), user_id: 2, conversation_id: convo.id)
Message.create(subject: Faker::Lorem.sentence, body: Faker::Lorem.paragraph(2), user_id: 1, conversation_id: convo.id)
Message.create(subject: Faker::Lorem.sentence, body: Faker::Lorem.paragraph(2), user_id: 2, conversation_id: convo.id)
Message.create(subject: Faker::Lorem.sentence, body: Faker::Lorem.paragraph(2), user_id: 1, conversation_id: convo.id)
Message.create(subject: Faker::Lorem.sentence, body: Faker::Lorem.paragraph(2), user_id: 2, conversation_id: convo.id)

10.times do
  Bid.create(amount: rand(20..100), description: Faker::Lorem.paragraph, gig_id: gig.id, user_id: rand(1..12))
end
