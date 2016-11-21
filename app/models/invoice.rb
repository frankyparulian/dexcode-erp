# == Schema Information
#
# Table name: invoices
#
#  id                  :integer          not null, primary key
#  client_id           :integer
#  company_id          :integer
#  subtotal            :float
#  tax_percent         :float
#  tax_amount          :float
#  total               :float
#  begin_date          :date
#  end_date            :date
#  created_at          :datetime
#  updated_at          :datetime
#  number              :string(255)
#  payment_information :text
#

class Invoice < ActiveRecord::Base
  include Numbered

  numbered :number, scope: :client_id, prefix: lambda { |invoice| invoice.client.code }

  belongs_to :company
  belongs_to :client
  has_many :invoice_items, dependent: :destroy
  has_many :documents, as: :documentable, dependent: :destroy

  accepts_nested_attributes_for :invoice_items,
                                reject_if: proc { |attrs| attrs['name'].blank? || attrs['amount'].blank? },
                                allow_destroy: true

  validates :client, presence: true
  validates :company, presence: true
  validates_numericality_of :subtotal, :tax_percent, :tax_amount, :total
end
