require 'rails_helper'

describe ReminderInterview do
  describe "self.perform" do

    it "interviewee reminder" do
      interview = Interview.create!(id: '1', email: 'james@gmail.com', name: 'James', schedule: DateTime.new(2014, 12, 8, 13, 0).to_s )
      expect { ReminderInterview.perform 1 }.to change { ActionMailer::Base.deliveries.count }.by 1
    end

  end
end
