# == Schema Information
#
# Table name: invites
#
#  id          :integer          not null, primary key
#  employee_id :integer
#  email       :string(255)
#  code        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

require 'rails_helper'

RSpec.describe Invite, :type => :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  before :each do
    @invite = FactoryGirl.create(:invite)
  end
end
