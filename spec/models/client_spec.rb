# == Schema Information
#
# Table name: clients
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  start_date      :date
#  end_date        :date
#  created_at      :datetime
#  updated_at      :datetime
#  company_id      :integer
#  billing_address :text
#  code            :string(255)
#

require 'rails_helper'

RSpec.describe Client, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
