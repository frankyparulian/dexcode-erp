require 'rails_helper'

describe EmployeesController do

  describe "GET index" do
    it "assigns @employee" do
      @user = FactoryGirl.create(:user)
      @company = FactoryGirl.create(:company, user: @user)
      sign_in @user

      employee = FactoryGirl.create(:employee, company: @company)
      get :index
      expect(response.status).to eq 200
      expect(assigns(:employees)).to eq [employee]
    end
  end

  describe "new" do
    before :each do
      @user = FactoryGirl.create(:user)
      @company = FactoryGirl.create(:company, user: @user)
      @employee = FactoryGirl.create(:employee)
      sign_in @user
    end

    it "assigns new" do
      get :new
      expect(assigns(:employee)).to be_present
    end

    it "check business owner" do
      @user = FactoryGirl.create(:user, role: 'employee')
      sign_in @user
      get :new
      expect(response).to redirect_to(root_path)
    end
  end

  describe "edit" do
    before :each do
      @user = FactoryGirl.create(:user)
      @company = FactoryGirl.create(:company, user: @user)
      sign_in @user
    end

    it "GET edit" do
      employee = FactoryGirl.create(:employee, company: @company)
      get :edit, id: employee.id
      expect(assigns(:employee)) != [employee.id]
    end
  end

  describe "update" do
    before :each do
      @user = FactoryGirl.create(:user)
      @company = FactoryGirl.create(:company, user: @user)
      sign_in @user
    end

    it "put update" do
      employee = FactoryGirl.create(:employee, company: @company)
      put :update, { id: employee.id, employee: {name: 'Steve Jobs'}}
      expect(assigns(:employee).name).to eq 'Steve Jobs'
    end

    it "put update" do
      employee = FactoryGirl.create(:employee, company: @company)
      put :update, { id: employee.id, employee: {name: 'Rahmat'}}
      expect(assigns(:employee).name).to eq 'Rahmat'
    end

    it "put update" do
      employee = FactoryGirl.create(:employee, company: @company)
      put :update, { id: employee.id, employee: {name: ''}}
      expect(assigns(:employee).name).to eq ''
    end
  end

  describe "create" do
    before :each do
      @user = FactoryGirl.create(:user)
      @company = FactoryGirl.create(:company, user: @user)
      @employee = FactoryGirl.create(:employee)
      sign_in @user
    end

    it "assigns create" do
      employee = FactoryGirl.create(:employee, company: @company)
      post :create, {employee: {name: 'abang', position: 'Programmer', start_date: Date.new(2014, 12, 1)}}
      expect(assigns(:employee).name).to eq 'abang'
      expect(assigns(:employee).position).to eq 'Programmer'
      expect(assigns(:employee).start_date).to eq Date.new(2014, 12, 1)
      expect(response).to redirect_to(employees_path)
    end

    it "assigns create" do
      employee = FactoryGirl.create(:employee, company: @company)
      post :create, {employee: {name: 'segi', position: 'Programmer', start_date: Date.new(2014, 12, 8)}}
      expect(assigns(:employee).name).to eq 'segi'
      expect(assigns(:employee).position).to eq 'Programmer'
      expect(assigns(:employee).start_date).to eq Date.new(2014, 12, 8)
      expect(response).to redirect_to(employees_path)
    end
  end

  describe "show" do
    before :each do
      @user = FactoryGirl.create(:user, role: 'employee')
      @company = FactoryGirl.create(:company, user: @user)
      @employee = FactoryGirl.create(:employee)
      @current_employee = FactoryGirl.create(:employee, user: @user, company: @company)
      sign_in @user
    end

    it "Redirect to current user employee page" do
      get :show, {id: @employee.id}
      expect(response).to redirect_to(employee_path(@user.employee.id))
    end

    it "Show current user employee page" do
      get :show, {id: @current_employee.id}
      expect(response).to have_http_status(200)
    end
  end

  describe "salaries" do
    before :each do
      @user = FactoryGirl.create(:user)
      @company = FactoryGirl.create(:company, user: @user)
      @current_employee = FactoryGirl.create(:employee, user_id: @user.id)
      @employee1 = FactoryGirl.create(:employee,
        company_id: @company.id,
        start_date: Date.new(2014, 12, 01),
        end_date: Date.new(2015, 01, 15))
      @employee2 = FactoryGirl.create(:employee,
        company_id: @company.id,
        start_date: Date.new(2014, 12, 01),
        end_date: Date.new(2015, 01, 15))
      sign_in @user
    end

    it "check your salaries test first" do
      @month = 11
      @year = 2014
      get :salaries, {id: @current_employee.id, month: @month, year: @year}
    end


    it "check your salaries test first" do
      @month = 12
      @year = 2014
      get :salaries, {id: @current_employee.id, month: @month, year: @year}
    end

    it "check your salaries test second" do
      @month = 1
      @year = 2015
      get :salaries, {id: @current_employee.id, month: @month, year: @year}
    end

    it "check your salaries test second" do
      @month = 2
      @year = 2015
      get :salaries, {id: @current_employee.id, month: @month, year: @year}
    end
  end

end
