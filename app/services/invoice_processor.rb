class InvoiceProcessor
  def process(invoice)
    invoice.tax_percent = 0 # Assume tax percent is 0 for now
    invoice.tax_amount = 0
    invoice.subtotal = subtotal(invoice)
    invoice.total = invoice.subtotal + invoice.tax_amount
  end

  def self.instance
    @processor ||= InvoiceProcessor.new
  end

  private

    def subtotal(invoice)
      _subtotal = 0
      invoice.invoice_items.each do |invoice_item|
        case invoice_item.type
        when 'fixed'
          _subtotal += invoice_item.amount
        when 'per_unit'
          _subtotal += invoice_item.quantity * invoice_item.unit_price
        end
      end
      _subtotal
    end

end