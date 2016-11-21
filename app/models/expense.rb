# == Schema Information
#
# Table name: expenses
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  total      :integer          default(0), not null
#  date       :date
#  created_at :datetime
#  updated_at :datetime
#  company_id :integer
#

class Expense < ActiveRecord::Base
  validates_numericality_of(:total)
  belongs_to :company

end
