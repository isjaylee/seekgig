class Bid < ActiveRecord::Base
  include SharedMethods
  belongs_to :gig
  belongs_to :user

  validate :one_bid_per_gig
  validates :user_id, :gig_id, presence: true
  validates :amount, numericality: true
  validates :amount, numericality: { greater_than_or_equal_to: 0 }

  default_scope { where(archived: false) }

  def one_bid_per_gig
    if Bid.find_by(gig_id: self.id, user_id: user.id)
      errors.add(:base, "Cannot bid multiple times on one gig.")
    end
  end
end
