# == Schema Information
#
# Table name: employees
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  position            :string(255)
#  salary              :integer          default(0), not null
#  salary_currency     :string(255)      default("IDR"), not null
#  created_at          :datetime
#  updated_at          :datetime
#  start_date          :date
#  end_date            :date
#  ktp                 :string(255)
#  user_id             :integer
#  company_id          :integer
#  bank_name           :string(255)
#  bank_account_number :string(255)
#  photo               :string(255)
#  bank_account_holder :string(255)
#

require 'rails_helper'

describe Employee do
  describe ".monthly_salary" do
    before :each do
      @employee = FactoryGirl.create(:employee, salary: 1000,
      start_date: Date.new(2014, 5, 1))
    end

    it "returns salary correctly" do
      expect(@employee.monthly_salary(6, 2014)).to eq 1000
    end

    it "returns salary correctly when employee is absence" do
      total_work_days = @employee.total_work_days(6, 2014)
      expect(total_work_days).to eq 21

      @employee.employee_absences.create(date: Date.new(2014, 6, 16), reason: "Some Reason", use_sick_days: false)

      @employee.reload

      paid_work_days = @employee.paid_work_days(6, 2014)
      expect(paid_work_days).to eq 20

      expect(@employee.monthly_salary(6, 2014)).to eq (20.to_f / 21.to_f * 1000)
    end
  end

  describe ".total_work_days" do
    # TODO
  end

  describe ".total_absence_using_sick_days" do
    before :each do
      @employee = FactoryGirl.create(:employee,
      start_date: Date.new(2014, 5, 1))
    end

    it "returns total absence correctly" do
      @employee.employee_absences.create(date: Date.new(2014, 6, 16), reason: "Some Reason", use_sick_days: true)
      expect(@employee.total_absence_using_sick_days).to eq 1
    end
  end

  describe "vacation" do
    before :each do
      @employee = FactoryGirl.create(:employee,
      start_date: Date.new(2014, 5, 1))
    end

    it "returns total absence correctly" do
      Timecop.freeze(Date.new(2015, 1, 1)) do
        expect(@employee.vacation).to eq 8
        @employee.employee_absences.create(date: Date.new(2014, 7, 16), reason: "Some Reason", use_sick_days: true)
        expect(@employee.vacation).to eq 7
      end
    end
  end

  describe ".number_of_work_days" do
    before :each do
      @employee = FactoryGirl.create(:employee,
      start_date: Date.new(2014, 5, 1))
    end

    it "return number of work days correctly" do
      expect(@employee.number_of_work_days(6, 2014)).to eq 21
    end
  end

  describe "day left after resign" do
    before :each do
      @employee = FactoryGirl.create(:employee,
      start_date: Date.new(2014, 5, 1), end_date: Date.new(2014, 6, 1))
    end

    it "else if day left after resign" do
      @month = 6
      @year = 2014
      {id: @employee.id, month: @month, year: @year}
      expect(@employee.days_left_after_resign(@month, @year)).to eq 21
    end
  end

  describe 'net_salary' do
    let(:employee) do 
      FactoryGirl.create(
        :employee,
        salary: 4_000_000,
        start_date: Date.new(2014, 5, 1))
    end

    it 'return employee bpjs correctly' do
      expect(employee.employee_bpjs).to eq 103_625.0
    end

    it 'return zero employee tax for female, married and no npwp correctly' do
      employee.status = 'married'
      employee.gender = 'female'
      employee.no_npwp = nil
      employee.save!
      expect(employee.employee_tax).to eq 0
    end

    it 'return employee net salary for male, single, no npwp correctly and small salary' do
      employee.status = 'single'
      employee.gender = 'male'
      employee.no_npwp = nil
      employee.salary = 2_000_000
      employee.save!
      expect(employee.net_salary).to eq 1_936_375
    end

    it 'return employee net salary for male, single, no npwp correctly' do
      employee.status = 'single'
      employee.gender = 'male'
      employee.no_npwp = nil
      employee.save!
      expect(employee.net_salary).to eq 2_548_985
    end

    it 'return employee net salary for male, single, with npwp correctly' do
      employee.status = 'single'
      employee.gender = 'male'
      employee.no_npwp = '12345'
      employee.save!
      expect(employee.net_salary).to eq 2_773_550
    end

    it 'return employee net salary for male, married, no npwp correctly' do
      employee.status = 'married'
      employee.gender = 'male'
      employee.no_npwp = nil
      employee.save!
      expect(employee.net_salary).to eq 2_548_985
    end

    it 'return employee net salary for male, married, with npwp correctly' do
      employee.status = 'married'
      employee.gender = 'male'
      employee.no_npwp = '12345'
      employee.save!
      expect(employee.net_salary).to eq 2_874_800
    end
  end
end
