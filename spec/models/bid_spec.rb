require 'rails_helper'

describe Bid do
  context ".association & validations" do
    it { should belong_to(:user) }
    it { should belong_to(:gig) }
    it { should validate_presence_of(:user_id) }
  end
end