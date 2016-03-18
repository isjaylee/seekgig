class ConversationsController < ApplicationController
  include ApplicationHelper

  def index
    @conversations = Conversation.where("recipient_id = ? or sender_id = ?", current_user, current_user).order(updated_at: :desc)
  end

  def show
    @conversation = Conversation.find(params[:id])
  end

  def destroy
    @conversation = Conversation.find(params[:id])
    @conversation.archive
    redirect_to(:back)
  end
end