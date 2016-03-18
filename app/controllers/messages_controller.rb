class MessagesController < ApplicationController

  def show
  end
 
  def create
    @conversation = Conversation.find(params[:conversation_id])
    @message = @conversation.messages.build(message_params.merge(user_id: current_user.id))
    @recipient = get_recipient
    if @message.save
      @conversation.touch
      MessageMailer.message_sent(current_user, @recipient, @message).deliver
      redirect_to user_conversation_path(params[:user_uid], @conversation)
    else
      flash[:alert] = @message.errors.full_messages.to_sentence
      redirect_to gig_bids_path(@gig.uid)
    end
  end

  def new_message
    @recipient = User.find_by(uid: params[:user_uid])
    @conversation = Conversation.new(sender_id: current_user.id, recipient_id: @recipient.id)
    @message = @conversation.messages.build(message_params.merge(user_id: current_user.id))
    if @message.save
      MessageMailer.message_sent(current_user, @recipient, @message).deliver
      redirect_to(:back)
    else
      flash[:alert] = @message.errors.full_messages.to_sentence
      redirect_to gig_bids_path(@gig.uid)
    end
  end
 
  private

    def message_params
      params.require(:message).permit(:body, :subject)
    end

    def get_recipient
      current_user == User.find(@conversation.recipient_id) ? User.find(@conversation.sender_id) : User.find(@conversation.recipient_id)
    end

end