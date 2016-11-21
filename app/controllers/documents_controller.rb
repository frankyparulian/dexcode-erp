# Handle request based on document files
class DocumentsController < ApplicationController
  def create
    @invoice = current_company.invoices.find(params[:invoice_id])
    html = render_to_string('invoices/pdf.html.erb', layout: nil)
    pdf = WickedPdf.new.pdf_from_string(html)
    tempfile = create_tmp_file(pdf)
    # Save pdf file to database
    save_document(@invoice, tempfile)
    redirect_to invoices_url(client_id: @invoice.client_id)
  end

  def show
    document = Document.find(params[:id])
    # Get pdf file path
    pdf_path = document.document.file.file
    # Read pdf file
    pdf = File.read(pdf_path)
    # Send pdf file to be download
    send_data(pdf, filename: 'invoice.pdf', disposition: 'attachment')
  end

  def destroy
    document = Document.find(params[:id])
    document.destroy
    invoice = Invoice.find(document.documentable_id)
    redirect_to invoices_path(client_id: invoice.client_id)
  end

  private

  def save_document(invoice, pdf)
    document = Document.new
    document.document = pdf
    document.documentable_id = invoice.id
    document.documentable_type = 'invoice'
    document.save
  end

  def create_tmp_file(pdf)
    tempfile = Tempfile.new(['invoice', '.pdf'], Rails.root.join('tmp'))
    tempfile.binmode
    tempfile.write(pdf)
    tempfile.close
    tempfile
  end
end
