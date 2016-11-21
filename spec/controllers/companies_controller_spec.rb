require 'rails_helper'

describe CompaniesController do



  describe "new" do

    before :each do
      @user = FactoryGirl.create(:user)
      @company = FactoryGirl.create(:company, user: @user)
      sign_in @user
    end

    it "new company return true" do
      get :new
      expect(response.status).to eq 200
      expect(assigns(:company)).to be_present
    end

  end

  describe "create" do

    before :each do
      @user = FactoryGirl.create(:user)
      @company = FactoryGirl.create(:company, user: @user)
      sign_in @user
    end

    it "assigns create" do
      company = FactoryGirl.create(:company, user: @user)
      expect(response.status).to eq 200
      post :create, {company: {name: 'abang'}}
      expect(assigns(:company).name).to eq 'abang'
      expect(response).to redirect_to(employees_path)
    end

    it "assigns create" do
      company = FactoryGirl.create(:company, user: @user)
      expect(response.status).to eq 200
      post :create, {company: {name: 'Rahmat'}}
      expect(assigns(:company).name).to eq 'Rahmat'
      expect(response).to redirect_to(employees_path)
    end
  end

  describe "edit" do

    before :each do
      @user = FactoryGirl.create(:user)
      @user_2 = FactoryGirl.create(:user)
      @company = FactoryGirl.create(:company, user: @user)
      sign_in @user_2
    end

    it "ensure company exists!" do
        get :edit, { id: @company.id }
        expect(response).to redirect_to(new_company_path)
    end
  end

end
