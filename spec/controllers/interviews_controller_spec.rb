require 'rails_helper'

describe InterviewsController do

  describe "index" do
    before :each do
      @user = FactoryGirl.create(:user)
      @company = FactoryGirl.create(:company, user: @user)
      sign_in @user
    end

    it "index interview" do
      get :index
      expect(response.status).to eq 200
    end

    it 'returns interviews for the given day' do
      @interview1 = @company.interviews.create!(name: 'Interviewee 1', email: 'interviewee1@gmail.com', schedule: DateTime.now)
      @interview2 = @company.interviews.create!(name: 'Interviewee 2', email: 'interviewee2@gmail.com', schedule: DateTime.now)
      @interview3 = @company.interviews.create!(name: 'Interviewee 3', email: 'interviewee3@gmail.com', schedule: DateTime.now + 1)

      get :index
      expect(assigns[:interviews]).to eq [@interview1, @interview2]
    end
  end

  describe "get interview" do
    before :each do
      @user = FactoryGirl.create(:user)
      @company = FactoryGirl.create(:company, user: @user)
      sign_in @user
    end

    it "get interview status" do
      post :index
      expect(response.status).to eq 200
    end

    it "get interview by schedule" do
      @interview1 = @company.interviews.create!(name: 'Interviewee 1', email: 'interviewee1@gmail.com', schedule: DateTime.now)
      @interview2 = @company.interviews.create!(name: 'Interviewee 2', email: 'interviewee2@gmail.com', schedule: DateTime.now)
      @interview3 = @company.interviews.create!(name: 'Interviewee 3', email: 'interviewee3@gmail.com', schedule: DateTime.now + 1)

      date = Date.new(2014, 12, 8)
      @interviews = @company.interviews.where("schedule >= ? AND schedule < ?", date.to_date, date.to_date+1.day)
      post :get_interviewee, {interview: {schedule: Date.new(2014, 12, 8)}}
      expect(assigns(:interviews).to_json).to eq @interviews.to_json
      expect(response.body).to eq @interviews.to_json
    end

  end

  describe "create" do
    before :each do
      @user = FactoryGirl.create(:user)
      @company = FactoryGirl.create(:company, user: @user)
      sign_in @user
    end

    it "if @interview.save" do
      interview = @company.interviews.create!(name: 'james', email: 'james@gmail.com', schedule: DateTime.new(2014, 12, 8, 13, 0).to_s)
      post :create, {
        format: :json,
        interview: {
          name: 'james',
          email: 'interviewee1@gmail.com',
          schedule: DateTime.new(2014, 12, 8, 13, 0).to_s
        }
      }
      expect(response.body).not_to eq nil

    end

    it "else @interview.save" do
      post :create, {format: :json, interview: {name: '', email: 'interviewee1@gmail.com', schedule: DateTime.new(2014, 12, 8, 13, 0).to_s}}
      expect(response.body).not_to eq nil
    end
  end

  describe "update state" do
    before :each do
      @user = FactoryGirl.create(:user)
      @company = FactoryGirl.create(:company, user: @user)
      sign_in @user
    end

    it "update state of interview" do
      interview = @company.interviews.create!(id: '1', name: 'Interviewee 1', email: 'interviewee1@gmail.com', schedule: DateTime.now, state: 'hired')

      put :update_state, {interview: {id: '1', state: 'hired'}}
      expect(assigns(:interview).state).to eq 'hired'
    end

  end

  describe "destroy" do
    before :each do
      @user = FactoryGirl.create(:user)
      @company = FactoryGirl.create(:company, user: @user)
      sign_in @user
    end

    it "if @interview is destroy" do
      interview = @company.interviews.create!(id: '1', name: 'Interviewee 1', email: 'interviewee1@gmail.com', schedule: DateTime.now)
      get :destroy, {id: '1'}

      expect(interview.destroy).to eq interview

      expect(response).to redirect_to(interviews_path)
      expect(flash[:notice]).to eq "Interview was deleted"
    end

    it "else @interview is destroy" do
      interview = @company.interviews.create!(id: '1', name: 'james', email: 'interviewee1@gmail.com', schedule: DateTime.now)

      Interview.any_instance.stub(:destroy).and_return(false)

      get :destroy, {id: '1'}

      expect(response).to redirect_to(interviews_path)
      expect(flash[:alert]).to eq "Interview delete failed"
    end

  end

end
