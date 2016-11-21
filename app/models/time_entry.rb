# == Schema Information
#
# Table name: time_entries
#
#  id          :integer          not null, primary key
#  employee_id :integer          not null
#  project_id  :integer          not null
#  hours       :float            not null
#  date        :date             not null
#  created_at  :datetime
#  updated_at  :datetime
#

# Store working time information
class TimeEntry < ActiveRecord::Base
  validates :employee_id, presence: true
  validates :project_id, presence: true
  validates :hours, presence: true
  validates :date, presence: true

  belongs_to :project
  belongs_to :employee

  class << self
    def sum_by_project_and_date_sql(project_id, first_date, last_date)
      select('sum(hours)')
      .where('employee_id = employees.id')
      .where(project_id: project_id, date: first_date..last_date).to_sql
    end

    def timesheet_scope
      select(
        "(#{Employee.query_name_by_time_entries}) AS employee_name",
        "(#{Project.query_name_by_time_entries}) AS project_name",
        'sum(hours) as hours',
        :date, :employee_id, :project_id
      )
    end

    def timesheet_data(project_ids, employee_ids, first_date, last_date)
      timesheet_scope
        .where(project_id: project_ids, employee_id: employee_ids, date: first_date..last_date)
        .group('employee_id, project_id, MONTH(date)')
    end

    def data_report_time_entries(project)
      @project = EmployeeProject.where(project_id: project).order(:employee_id)

      select = 'date'
      sheet_data = []
      if @project
        @project.each do |pro|
          @employee = Employee.find(pro.employee_id)
          select = subquery_for_data_report_time_entries(project, pro, select)
          sheet_data.push @employee.name
        end
      end
      @time_entries = select("te.#{select}")
            .where("te.project_id = #{project}")
            .from('time_entries as te')
            .group('te.date')
            .order('te.date')
      result = {
        project: @project,
        sheet_data: sheet_data,
        time_entries: @time_entries
      }
      result
    end

    private

    def subquery_for_data_report_time_entries(id, project, select)
      subquery = TimeEntry.select(:hours)
        .where('date = te.date')
        .where(project_id: id)
        .where(employee_id: project.employee_id)
        .limit(1).to_sql
      select += ", IFNULL((#{subquery}),0) as employee_#{@employee.id}"
      select
    end
  end
end
