require 'rails_helper'

describe Gig do
  context ".association & validations" do
    it { should belong_to :user }
    it { should belong_to :category }
    it { should have_many :images }
    it { should have_many :reviews }
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :budget }
    it { should validate_presence_of :location }
  end

  describe ".methods" do
    let!(:gig) { create(:gig, location: "Chicago", name: "Dentist") }
    let!(:gig_two) { create(:gig, location: "Skokie", name: "Plumber") }
    let!(:gig_three) { create(:gig, location: "San Francisco", name: "Plumber") }
    let!(:gig_four) { create(:gig, location: "Chicago", status: 1) }

    context "search_all" do

      before :each do
        Gig.reindex
        Gig.searchkick_index.refresh
      end

      context "finds no gigs if location is empty" do
        subject { Gig.search_all({search: "Plumber"}) }
        it { expect(subject.first).to eq nil }
        it { expect(subject.count).to eq 0 }
      end

      context "finds a gig by name in given location with open status" do
        subject { Gig.search_all({search: "Plumber", location: "San Francisco"}) }
        it { expect(subject.first).to eq gig_three }
        it { expect(subject.count).to eq 1 }
        it { expect(subject.first.status).to eq "open" }
      end

      context "finds a gig by location" do
        subject { Gig.search_all({search: "", location: "San Francisco"}) }
        it { expect(subject.first).to eq gig_three }
        it { expect(subject.count).to eq 1 }
        it { expect(subject.first.status).to eq "open" }
      end

      context "finds a gig by location around 25 miles" do
        subject { Gig.search_all({search: "", location: "Chicago"}) }
        it { expect(subject.count).to eq 2 }
        it { expect(subject.map(&:name)).to eq ["Plumber", "Dentist"] }
        it { expect(subject.first).to eq gig_two }
      end

    end
  end
end
