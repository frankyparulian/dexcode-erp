require 'rails_helper'

describe InvitesController do

  before do
    @user = FactoryGirl.create(:user)
    @company = FactoryGirl.create(:company, user: @user)
    sign_in @user
  end


  describe "create" do
    before do
      @employee1 = FactoryGirl.create(:employee, id: '1')
      @invite = FactoryGirl.create(:invite)
    end

    it "create a invitation success" do
      params = { invite: { email: @invite.email, employee_id: @invite.employee_id } }
      post :create, params
      expect(assigns(:employee).invite).to eq @invite
      expect(response).to redirect_to(employees_path)
    end

    it "create a invitation failed" do
      params = { invite: { email: '', employee_id: ''} }
      expect{post :create, params}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

end
