class ExpensesController < ApplicationController
  before_action :check_business_owner, except: [:index, :show]
  before_action :ensure_employee, only: [:show]
  after_action :verify_authorized

  def index
    authorize(:expense)
    @expenses = current_company.expenses.all

  end

  def new
    authorize(:expense)
    @expense = Expense.new
  end

  def create
    authorize(:expense)
    @expense = current_company.expenses.new(expense_params)
    @expense.save!
    redirect_to expenses_path, :notice => "Successfull Add New Expense"
  end

  def edit
    authorize(:expense)
    @expense = current_company.expenses.find(params[:id])
  end

  def update
    authorize(:expense)
    @expense = current_company.expenses.find(params[:id])
    if @expense.update(expense_params)
      redirect_to expenses_path, :notice => "Successfull Edit Expense"
    else
      redirect_to edit_expense_path, :alert => "Failed Edit Expense"
    end
  end

  def destroy
    authorize(:expense)
    @expense = current_company.expenses.find(params[:id])
    @expense.destroy
    redirect_to expenses_path, :notice => "Successfull Delete Expense"
  end

  private
  def expense_params
    params.require(:expense).permit(:name, :total, :date)
  end

end
