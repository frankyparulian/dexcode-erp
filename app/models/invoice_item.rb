# == Schema Information
#
# Table name: invoice_items
#
#  id         :integer          not null, primary key
#  invoice_id :integer
#  name       :string(255)
#  quantity   :float
#  unit_price :float
#  amount     :float
#  type       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class InvoiceItem < ActiveRecord::Base
  self.inheritance_column = nil

  belongs_to :invoice

  validates_numericality_of :amount
  validates :type, format: { with: /\A(fixed|per_unit)\z/ }
end
