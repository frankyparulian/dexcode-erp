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
#  ancestry            :string(255)
#  parent              :integer
#  no_npwp             :string(255)
#  status              :integer
#  child               :integer
#  gender              :integer
#  date_of_birth       :date
#
# Indexes
#
#  index_employees_on_ancestry  (ancestry)
#  index_employees_on_parent    (parent)
#

class Employee < ActiveRecord::Base
  PTKP = 24_300_000
  FAMILY_ALLOWANCE = 2_025_000
  CHILDREN_ALLOWANCE = 2_025_000
  BPJS_IURAN_KESEHATAN = 23_625
  BPJS_BATAS_GAJI_TERTINGGI = 4_725_000

  attr_accessor :computed_salary, :absences, :work_days, :actual_work_days,
                :actual_paid_work_days, :vacations

  mount_uploader :ktp, UnprocessedUploader
  mount_uploader :photo, UnprocessedUploader

  monetize :salary

  enum status: { single: 0, married: 1 }
  enum gender: { male: 0, female: 1 }

  with_options dependent: :destroy do |c|
    c.has_one :invite
    c.has_many :employee_absences
    c.has_many :time_entries
    c.has_many :employee_projects
  end

  has_many :projects, through: :employee_projects
  has_many :salary_histories, dependent: :destroy

  belongs_to :user
  belongs_to :company

  validates :name, presence: true
  validates :position, presence: true
  validates :start_date, presence: true

  after_save :create_history

  delegate :invitation_accepted?, :invited_to_sign_up?, to: :user, allow_nil: true

  class << self
    #
    # Return all employees who are still active for the given period
    #
    def active(start_period = nil, end_period = nil)
      if start_period.nil? || end_period.nil?
        today = Date.today
        start_period = Date.new(today.year, today.month, 1)
        end_period = Date.new(today.year, today.month, -1)
      end

      where('
        start_date <= :end_period AND
        (
          end_date IS NULL OR
          (:start_period <= end_date AND end_date <= :end_period) OR
          :end_period <= end_date
        )',
        {
          start_period: start_period,
          end_period: end_period
        }
      )
    end

    def sum_hours(project_ids, first_date, last_date)
      time_entries = TimeEntry.sum_by_project_and_date_sql(project_ids, first_date, last_date)
      select("id,name, (#{time_entries}) as sum_hours")
    end

    def query_name_by_time_entries
      select(:name)
        .where('id = time_entries.employee_id')
        .to_sql
    end
  end

  def create_history
    history = SalaryHistory.where(employee_id: id).order(id: :desc).first
    unless history && history.salary == salary && history.salary_currency == salary_currency
      save_history = salary_histories.new
      save_history.salary = salary
      save_history.salary_currency = salary_currency
      save_history.save
    end
  end

  def net_salary
    salary - employee_bpjs - employee_tax
  end

  def employee_tax
    return 0 unless taxed_salary?
    ptkp = PTKP

    if married_male_with_npwp?
      ptkp += FAMILY_ALLOWANCE
      ptkp += child * CHILDREN_ALLOWANCE if child.present?
    end

    tax = if annual_salary_before_tax > ptkp
            0.05 * (annual_salary_before_tax - ptkp)
          else
            0
          end

    tax *= 1.2 unless no_npwp.present?
    tax
  end

  def taxed_salary?
    status != 'married' || gender == 'male' || no_npwp.present?
  end

  def married_male_with_npwp?
    status == 'married' && gender == 'male' && no_npwp.present?
  end

  def annual_salary
    salary * 12
  end

  def annual_bpjs
    employee_bpjs * 12
  end

  def annual_salary_before_tax
    annual_salary - annual_bpjs
  end

  def employee_monthly_tax
    employee_tax / 12
  end

  def employee_bpjs
    bpjs_kerja = salary * 0.02
    bpjs_kerja + BPJS_IURAN_KESEHATAN
  end

  def employer_bpjs
    bpjs_kerja = (4.25 / 100) * salary
    bpjs_kesehatan = (4.0 / 100) * BPJS_BATAS_GAJI_TERTINGGI
    bpjs_kerja + bpjs_kesehatan
  end

  def monthly_salary(month, year)
    salary.to_f * (paid_work_days(month, year).to_f / total_work_days(month, year).to_f)
  end

  def paid_work_days(month, year)
    actual_total_work_days(month, year) + number_of_paid_absences(month, year)
  end

  def actual_total_work_days(month, year)
    begin_period = Date.new(year, month, 1)
    end_period = begin_period + 1.months
    if begin_period <= start_date && start_date <= end_period
      holidays_count = company.holidays.where(['date >= ? AND date < ?', start_date, end_period]).count
      start_date.business_days_until(end_period) - holidays_count - number_of_absences(month, year) - days_left_after_resign(month, year)
    elsif end_period < start_date || begin_period > Date.today
      0
    else
      total_work_days(month, year) - number_of_absences(month, year) - days_left_after_resign(month, year)
    end
  end

  #
  # The number of employee work days at the given month
  #
  def number_of_work_days(month, year)
    total_work_days(month, year) - number_of_absences(month, year)
  end

  def number_of_paid_absences(month, year)
    begin_period = Date.new(year, month, 1)
    end_period = begin_period + 1.month
    employee_absences.where(
      'date >= ? AND date < ? AND use_sick_days = ?',
      begin_period,
      end_period,
      true
    ).count
  end

  def number_of_joint_holidays(month, year)
    begin_period = Date.new(year, month, 1)
    end_period = begin_period + 1.month
    Holiday.where(
      'date >= ? AND date < ? AND is_joint_holiday = ?',
      begin_period,
      end_period,
      true
    ).count
  end

  #
  # The number of this employee absence at the given month
  #
  def number_of_absences(month, year)
    begin_period = Date.new(year, month, 1)
    end_period = begin_period + 1.month
    employee_absences.where(
      'date >= ? AND date < ?',
      begin_period,
      end_period
    ).count
  end

  def days_left_after_resign(month, year)
    begin_period = Date.new(year, month, 1)
    end_period = begin_period + 1.month
    if end_date.nil?
      days_left_after_resign = 0
    elsif end_date >= begin_period && end_date <= end_period
      days_left_after_resign = end_date.business_days_until(end_period)
    else
      days_left_after_resign = 0
    end
    days_left_after_resign
  end

  #
  # The total number of work days at a given month
  #
  def total_work_days(month, year)
    begin_period = Date.new(year, month, 1)
    end_period = begin_period + 1.months
    begin_period.business_days_until(end_period) - company.holidays.number_of_holidays(month, year)
  end

  def vacation
    total_month - total_employee_month - total_absence_using_sick_days - total_joint_holidays
  end

  #
  # The total number of absence of employee that use sick days
  #
  def total_absence_using_sick_days
    begin_period = start_date
    end_period = Date.today
    employee_absences.where(
      'date >= ? AND date <= ? AND use_sick_days = ?',
      begin_period, end_period, true
    ).count
  end

  def total_joint_holidays
    begin_period = start_date
    end_period = Date.today
    Holiday.where(
      'date >= ? AND date <= ? AND is_joint_holiday = ?',
      begin_period, end_period, true
    ).count
  end

  def total_month
    today = Date.today
    today.year * 12 + today.month
  end

  def total_employee_month
    start_date.year * 12 + start_date.month
  end
end
