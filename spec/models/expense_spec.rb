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

require 'rails_helper'

RSpec.describe Expense, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
