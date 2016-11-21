# Handling Feedback request
class FeedbacksController < ApplicationController
  skip_before_action :authenticate_user!, except: [:create]

  def create
    client = Client.find(params[:client_id])
    feedback = Feedback.new(client_id: client.id)
    feedback.gid = feedback.generate_gid
    feedback.save
    FeedbackMailer.feedback(client, feedback).deliver
    redirect_to clients_url, notice: 'Feedback Sent!'
  end

  def show
    feedback = Feedback.find_by(gid: params[:gid])
    if feedback
      @feedback_valid = false
      render 'thanks' if feedback.content.present?
    else
      redirect_to root_url unless Feedback.find_by(gid: params[:gid])
    end
  end

  def update
    feedback = Feedback.find_by(gid: params[:gid])
    feedback.content = params[:content]
    feedback.rating = params[:rating]
    feedback.allow_publish = params[:allow_publish]
    feedback.save
    @feedback_valid = true
    render 'thanks'
  end

  def thanks
  end
end
