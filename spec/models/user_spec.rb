require 'rails_helper'

describe User do
  let!(:user_with_username) { create(:user, email: "test@test.com") }

  context ".association & validations" do
    it { should have_many :gigs }
    it { should have_many :bids }
    it { should have_many :messages }
    it { should have_many :reviews }
    it { should validate_presence_of :username }
    it { should validate_uniqueness_of(:username).case_insensitive }
  end

  context ".custom validations" do
    it { should allow_value("test2@test.com").for(:username) }
    it { should_not allow_value("test@test.com").for(:username) }
  end

  describe ".methods" do
    let!(:user) { create(:user, :with_review, location: "Chicago") }
    let!(:user_two) { create(:user, :with_review, location: "Skokie") }
    let!(:user_three) { create(:user, location: "San Francisco", firstname: "Fred") }
    let!(:user_four) { create(:user, location: "Chicago") }

    context "search_all" do

      before :each do
        User.reindex
        User.searchkick_index.refresh
      end

      context "finds no users if location is empty" do
        subject { User.search_all({search: ""}) }
        it { expect(subject.first).to eq nil }
        it { expect(subject.count).to eq 0 }
      end

      context "finds a user by name in given location with open status" do
        subject { User.search_all({search: "Fred", location: "San Francisco"}) }
        it { expect(subject.first).to eq user_three }
        it { expect(subject.count).to eq 1 }
      end

      context "finds a user by location" do
        subject { User.search_all({search: "", location: "San Francisco"}) }
        it { expect(subject.first).to eq user_three }
        it { expect(subject.count).to eq 1 }
      end

      context "finds a user by location around 25 miles" do
        subject { User.search_all({search: "", location: "Chicago", rating: "4"}) }
        it { expect(subject.count).to eq 2 }
        it { expect(subject.map(&:id)).to eq [user.id, user_two.id] }
      end

    end
  end
end
