class BidsController < ApplicationController

  before_action :authenticate_user!, only: %i[new create]

  def index
    @gig = Gig.find_by(uid: params[:gig_uid])
    @bids = @gig.bids
  end

  def new
    redirect_to gig_path(params[:gig_uid])
  end

  def create
    @gig = Gig.find_by(uid: params[:gig_uid])
    @bid = @gig.bids.new(bid_params.merge(user_id: current_user.id))
    if @bid.save
      BidMailer.receive_bid(current_user, @gig).deliver
      redirect_to gig_path(@gig.uid)
    else
      flash[:alert] = @bid.errors.full_messages.to_sentence
      redirect_to gig_path(@gig.uid)
    end
  end

  def show
    @gig = Gig.find_by(uid: params[:gig_uid])
  end

  def destroy
    @bid = Bid.find(params[:id])
    @bid.archive
    redirect_to dashboard_path
  end

  private
    def bid_params
      params.require(:bid).permit(:amount, :description)
    end
end
