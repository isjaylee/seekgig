require 'rails_helper'

describe Review do
  context ".association & validations" do
    it { should belong_to :user }
    it { should belong_to :gig }
    it { should validate_presence_of :user_id }
    it { should validate_presence_of :gig_id }
  end
end