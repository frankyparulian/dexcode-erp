# == Schema Information
#
# Table name: holidays
#
#  id         :integer          not null, primary key
#  date       :date
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  company_id :integer
#

class Holiday < ActiveRecord::Base
  belongs_to :company

  class << self
    def number_of_holidays(month, year)
      begin_period = Date.new(year, month, 1)
      end_period = Date.new(year, month, 1) + 1.month
      where(['date >= ? AND date < ?', begin_period, end_period]).count
    end
  end
end
