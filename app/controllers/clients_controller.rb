class ClientsController < ApplicationController
  before_action :check_business_owner, except: [:index, :show]
  before_action :ensure_employee, only: [:show]
  after_action :verify_authorized

  def index
    authorize(:employee)
    @clients = current_company.clients.all
  end

  def new
    authorize(:employee)
    @client = Client.new
  end

  def create
    authorize(:employee)
    @client = current_company.clients.new(client_params)
    @client.save!
    redirect_to clients_path, notice: 'Client has been created.'
  end

  def edit
    authorize(:employee)
    @client = current_company.clients.find(params[:id])
  end

  def update
    authorize(:employee)
    @client = current_company.clients.find(params[:id])
    if @client.update(client_params)
      redirect_to clients_path, notice: 'Client has been updated.'
    else
      redirect_to edit_client_path, alert: record_error(@client)
    end
  end

  def destroy
    authorize(:employee)
    @client = current_company.clients.find(params[:id])
    @client.destroy
    redirect_to clients_path, notice: 'Client has been deleted.'
  end

  def show
    authorize(:employee)
    @client = Client.find(params[:id])
  end

  private

    def client_params
      params.require(:client).permit(
        :name, :email, :code,
        :start_date, :end_date, :billing_address)
    end
end
