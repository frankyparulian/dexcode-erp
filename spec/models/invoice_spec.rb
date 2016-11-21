# == Schema Information
#
# Table name: invoices
#
#  id          :integer          not null, primary key
#  client_id   :integer
#  company_id  :integer
#  subtotal    :float
#  tax_percent :float
#  tax_amount  :float
#  total       :float
#  begin_date  :date
#  end_date    :date
#  created_at  :datetime
#  updated_at  :datetime
#  number      :string(255)
#

require 'rails_helper'

describe Invoice do
  before :each do
    @company = FactoryGirl.create(:company)
    @client = FactoryGirl.create(:client, code: 'FN', email: 'client@mail.com')
  end

  it 'generates invoice number' do
    @invoice1 = FactoryGirl.create(:invoice, client: @client, company: @company)
    expect(@invoice1.number).to eq 'FN0001'

    @invoice2 = FactoryGirl.create(:invoice, client: @client, company: @company)
    expect(@invoice2.number).to eq 'FN0002'
  end
end
