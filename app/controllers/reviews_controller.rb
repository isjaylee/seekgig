class ReviewsController < ApplicationController

  def create
    @review = Review.new(review_params.merge(user_id: params[:user_uid].to_i))
    if @review.save
      redirect_to gig_bids_path(@review.gig.uid)
    else
      flash[:alert] = @review.errors.full_messages.to_sentence
      redirect_to gig_bids_path(@review.gig.uid)
    end
  end

  private

    def review_params
      params.require(:review).permit(:rating, :comment, :reviewer, :gig_id)
    end
end