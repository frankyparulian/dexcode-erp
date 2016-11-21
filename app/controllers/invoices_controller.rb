class InvoicesController < ApplicationController
  before_action :check_business_owner, except: [:index, :show]
  before_action :ensure_employee, only: [:show]
  after_action :verify_authorized

  def index
    authorize(:invoice)
    @clients = Client.find(params[:client_id])
    @invoices = @clients.invoices
  end

  def new
    authorize(:invoice)
    @client = Client.find(params[:client_id])
    @invoice = @client.invoices.new
  end

  def create
    authorize(:invoice)
    @invoice = current_company.invoices.new(invoice_params)
    InvoiceProcessor.instance.process(@invoice)
    if @invoice.save
      redirect_to invoices_path(client_id: @invoice.client.id), notice: 'Invoice has been created.'
    else
      flash[:alert] = record_error(@invoice)
      render 'new'
    end
  end

  def edit
    authorize(:invoice)
    @invoice = current_company.invoices.find(params[:id])
  end

  def update
    authorize(:invoice)
    @invoice = current_company.invoices.find(params[:id])
    if @invoice.update(invoice_params)
      redirect_to invoices_path(client_id: @invoice.client.id), notice: 'Invoice has been updated.'
    else
      redirect_to edit_invoice_path(@invoice), alert: record_error(@invoice)
    end
  end

  def destroy
    @invoice = current_company.invoices.find(params[:id])
    @client_id = @invoice.client_id
    @invoice.destroy
    redirect_to invoices_path(client_id: @client_id), notice: 'Invoice has been deleted.'
  end

  def show
    authorize(:invoice)
  end

  private

  def invoice_params
    params.require(:invoice).permit(
      :name_project, :total, :begin_date,
      :end_date, :client_id, :payment_information,
      invoice_items_attributes: [
        :id, :name, :quantity, :unit_price, :amount, :type, :_destroy
      ]
    )
  end
end
