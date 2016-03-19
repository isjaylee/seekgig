class BidMailer < ActionMailer::Base
  default from: "seekgig@gmail.com"

  def receive_bid(bidder, gig)
    @bidder = bidder
    @gig = gig
    mail(to: gig.user.email, subject: "#{bidder.username} has subbmitted a bid to #{gig.name}!")
  end

  def select_bid(bidder, gig)
    @bidder = bidder
    @gig = gig
    mail(to: @bidder.email, subject: "#{gig.user.username} has selected your bid on #{gig.name}!")
  end
end
