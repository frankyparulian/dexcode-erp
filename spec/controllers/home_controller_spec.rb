require 'rails_helper'

describe HomeController do

  describe "index" do

    it "current user as a business owner" do
      @user_business_owner = FactoryGirl.create(:user)
      @company = FactoryGirl.create(:company, user_id: @user_business_owner.id)
      sign_in @user_business_owner

      get :index
      expect(@user_business_owner.business_owner?).to eq true
      expect(response).to redirect_to (employees_path)
    end

    it "current user as a employee" do

      @user_employee = FactoryGirl.create(:user, role: "employee")
      @company = FactoryGirl.create(:company, user_id: @user_employee.id)
      @employee = FactoryGirl.create(:employee, user_id: @user_employee.id)
      sign_in @user_employee

      get :index
      expect(@user_employee.employee?).to eq true
      expect(response).to redirect_to (employee_path(@user_employee.employee))
    end

  end

end
