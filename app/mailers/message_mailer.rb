class MessageMailer < ActionMailer::Base
  default from: "seekgig@gmail.com"

  def message_sent(sender, receiver, message)
    @sender = sender
    @receiver = receiver
    @message = message
    mail(to: @receiver.email, subject: "#{@sender.username} has sent you a message!")
  end
end