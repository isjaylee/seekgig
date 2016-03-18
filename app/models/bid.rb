class Bid < ActiveRecord::Base
  include SharedMethods
  belongs_to :gig
  belongs_to :user

  validates_uniqueness_of :user_id, scope: :gig_id
  validates :user_id, :gig_id, presence: true
  validates :amount, numericality: true
  validates :amount, numericality: { greater_than_or_equal_to: 0 }
end