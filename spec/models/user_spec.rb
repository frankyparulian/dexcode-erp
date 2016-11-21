# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default("")
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  role                   :string(255)      default("business_owner"), not null
#  invitation_token       :string(255)
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_id          :integer
#  invitations_count      :integer          default(0)
#

require 'rails_helper'

describe User do
  #  pending "add some examples to (or delete) #{__FILE__}"
  before :each do
    @user_business_owner = FactoryGirl.create(:user ,password: "password", role: "business_owner")
    @user_employee = FactoryGirl.create(:user ,password: "password", role: "employee")
  end

  it "returns business owner" do
    expect(@user_business_owner.business_owner?).to eq true
  end

  it "returns employee" do
    expect(@user_employee.employee?).to eq true
  end
end
