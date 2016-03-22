class GigsController < ApplicationController
  helper_method :sort_column, :sort_direction

  before_action :authenticate_user!, only: %i[new create mygigs]
  before_action :is_gig_owner?, only: %i[edit update]
  before_action :gig_closed, only: %i[show edit update]

  def index
  end

  def new
    @gig = Gig.new
  end

  def create
    @gig = current_user.gigs.build(gig_params)
    build_image
    if @gig.save
      redirect_to gig_path(@gig.uid)
    else
      flash[:alert] = @gig.errors.full_messages.to_sentence
      render :new
    end
  end

  def show
    @gig = find_gig
    @bid = Bid.new
    @bids = Bid.where(gig_id: @gig)
  end

  def edit
    @gig = find_gig
  end

  def update
    @gig = find_gig
    if @gig.update(gig_params)
      @gig.images.create(image: params[:gig][:image][:image]) if params[:gig][:image].present?
      redirect_to gig_path(@gig.uid)
    else
      flash[:alert] = @gig.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    @gig = find_gig
    @gig.archive
    redirect_to mygigs_path
  end

  def search_all
    params[:location] = "Minneapolis" if params[:location].empty?
    @search_gigs = Gig.search_all(params)
    @sorted_gigs = Gig.where(id: @search_gigs.map(&:id)).order(sort_column + " " + sort_direction).page(params[:page]).per(25)
    @gigs = sort_category ? @sorted_gigs.where(category_id: params[:category]) : @sorted_gigs
  end

  def select_bid
    @gig = Gig.find_by(uid: params[:gig_uid])
    @gig.update(awarded_bid: params[:bid_id], status: 1)
    @bid = Bid.find(params[:bid_id])
    BidMailer.select_bid(@bid.user, @gig).deliver
    redirect_to gig_bids_path(@gig.uid)
  end

  def deselect_bid
    @gig = Gig.find_by(uid: params[:gig_uid])
    @gig.update(awarded_bid: nil, status: 0)
    redirect_to gig_bids_path(@gig.uid)
  end

  def finish
    @gig = Gig.find_by(uid: params[:gig_uid])
    @gig.update(status: 2)
    redirect_to gig_bids_path(@gig.uid)
  end

  def update_status
    @gig = Gig.find_by(uid: params[:gig_uid])
    @gig.update(status: params[:status].to_i)
    redirect_to dashboard_path
  end

  private

    def gig_params
      params.require(:gig).permit(:name, :description, :budget,
                                  :location, :status, :awarded_bid,
                                  :category_id, :location)
    end

    def find_gig
      Gig.find_by(uid: params[:uid])
    end

    def is_gig_owner?
      @gig = find_gig
      if @gig.user != current_user
        redirect_to root_path
        flash[:alert] = "You are not authorized to view this gig."
      end
    end

    def gig_closed
      @gig = find_gig
      if @gig.finished? && @gig.finished? && current_user != @gig.user
        flash[:alert] = "Gig is finished."
        redirect_to root_path
      end
    end

    def sort_column
      Gig.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end

    def sort_category
      params[:category].present? && params[:category] != "All"
    end

    def build_image
      if params[:gig][:image].present?
        @gig.images.build(image: params[:gig][:image][:image])
      end
    end
end
