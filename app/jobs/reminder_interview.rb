class ReminderInterview
  @queue = :reminders_queue

  def self.perform(interview_id)
    interview       = Interview.find_by_id(interview_id)
    email           = interview.email
    name            = interview.name
    datetime        = interview.schedule
    IntervieweeMailer.interview_reminder(email, name, datetime).deliver!
  end
end
