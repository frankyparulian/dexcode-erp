class InterviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_business_owner
  after_action :verify_authorized, except: [:team]

  def index
    authorize(:interview)
    date = DateTime.now.to_date
    @interviews = current_company.interviews.where("schedule >= ? AND schedule < ?", date, date+1.day)
    unless @interviews.present?
      @interviews = "no interviews today"
    end
  end

  def new
    authorize(:interview)
  end

  def get_interviewee
    authorize(:interview)
    date = params[:interview][:schedule]
    @interviews = current_company.interviews.where("schedule >= ? AND schedule < ?", date.to_date, date.to_date+1.day)
    render json: @interviews
  end

  def create
    authorize(:interview)
    @interview       = current_company.interviews.new(interview_params)
    @name            = params[:interview][:name]
    @datetime        = DateTime.parse(params[:interview][:schedule])
    reminder_at = DateTime.new(@datetime.year, @datetime.month, @datetime.day, 8, 0, 0, '+7')
    if @interview.save

      Resque.enqueue_at(reminder_at, ReminderInterview, @interview.id)
      IntervieweeMailer.interview_invitation(@interview.email, @name, @datetime).deliver
      respond_to do |format|
        format.html
        format.json { api_success }
      end
    else
      respond_to do |format|
        format.html
        format.json { api_error(@interview) }
      end
    end
  end

  def update_state
    authorize(:interview)
    @state      = params[:interview][:state]
    @interview = current_company.interviews.find(params[:interview][:id])
    @interview.update(state: @state)
    render json: @interview.to_json
  end

  def destroy
    authorize(:interview)
    @interview = current_company.interviews.find(params[:id])
    if @interview.destroy
      respond_to do |format|
        format.html do
          redirect_to interviews_path, notice:  "Interview was deleted"
        end
        format.json do
          api_success()
        end
      end
    else
      respond_to do |format|
        format.html do
          redirect_to interviews_path, alert: "Interview delete failed"
        end
        format.json do
          api_error(@interview)
        end
      end
    end
  end

  private

  def interview_params
    params.require(:interview).permit(:name, :email, :schedule)
  end

end
