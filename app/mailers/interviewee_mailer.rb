class IntervieweeMailer < ApplicationMailer
  @default_email = "contact@dexcode.com"
  default from: @default_email, cc: @default_email

  add_template_helper(TimeDisplayHelper)
  include TimeDisplayHelper

  def interview_invitation(to, name, datetime)
    @name = name
    @datetime = datetime
    to = to
    subject = "Interview di Dexcode #{display_interview_datetime(datetime)}"
    mail(to: to, subject: subject)
  end

  def interview_reminder(to, name, datetime)
    @name     = name
    @datetime = datetime
    to = to
    subject = "Interview di Dexcode hari ini #{display_interview_time(datetime)}"
    mail(to: to, subject: subject)
  end
end
