class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :gig

  validates :user_id, :gig_id, presence: true

  def get_reviewer(review)
    User.find(review).fullname.titleize
  end
end