# Handle Feedback email
class FeedbackMailer < ApplicationMailer
  def feedback(client, feedback)
    subject = 'Feedback'
    @client = client
    @feedback = feedback

    mail(
      to: @client.email,
      subject: subject
    )
  end
end
