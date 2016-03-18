class UsersController < ApplicationController
  include ApplicationHelper
  before_action :authenticate_user!, only: %i[dashboard]

  def show
    @user = User.find_by(uid: params[:uid])
    @reviews = @user.reviews.order(created_at: :desc)
  end

  def update_searchable
    current_user.update_attribute(:searchable, params[:searchable])
    render nothing: true
  end

  def search_all
    params[:location] = "Minneapolis" if params[:location].nil? || params[:location].empty?
    @search_users = User.search_all(params)
    @users = User.where(id: @search_users.map(&:id)).page(params[:page]).per(25)
  end

  def dashboard
    @gigs = Gig.where(user_id: current_user).order(created_at: :desc)
    @bids = Bid.where(user: current_user).order(created_at: :asc)
  end

end