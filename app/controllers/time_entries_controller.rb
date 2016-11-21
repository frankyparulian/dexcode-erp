# Handle request for TimeEntry Model
class TimeEntriesController < ApplicationController
  before_action :project_list, only: [:index]

  def index
    time_entry_args = params[:time_entry]
    employee_id = @employees.first
    project_id = @projects.first
    week = current_week_of_year
    year = current_year
    if time_entry_args
      employee_id = time_entry_args[:employee_id]
      project_id = time_entry_args[:project_id]
      week = time_entry_args.fetch(:display_current_week, week).to_i
      year = time_entry_args.fetch(:display_current_year, year).to_i
      week_date = WeekDate.new(week: week, year: year)
      if time_entry_args[:previous] == 'true'
        week -= 1
        begin_date = week_date.previous_begin_date
        end_date = week_date.previous_end_date
        week_dates = week_date.previous_all_week_date
      elsif time_entry_args[:previous] == 'false'
        week += 1
        begin_date = week_date.next_begin_date
        end_date = week_date.next_end_date
        week_dates = week_date.next_all_week_date
      end
    end
    week_hours = WeekHours.new(
      employee_id: employee_id,
      project_id: project_id,
      week: week,
      year: year
    )
    @hours = week_hours.calculate
    @hours << {
      begin_date: begin_date,
      end_date: end_date,
      week_dates: week_dates,
      current_date: Date.current
    } if time_entry_args.present? && time_entry_args[:previous].present?
    respond_to do |format|
      format.html
      format.json { render json: @hours.to_json }
    end
  end

  def new
  end

  def create
    params[:employee_id] = params[:employee]
    create_and_update_time_entry(params)
    redirect_to time_entries_url
  end

  private

    def create_and_update_time_entry(args)
      dates = args[:dates]
      hours = args[:hours]
      0.upto(6) do |n|
        next if dates[n].to_date > Date.current
        time_entry = TimeEntry.find_by(
          employee_id: args[:employee_id],
          project_id: args[:project_id],
          date: dates[n]
        )
        if time_entry
          time_entry.update(hours: hours[n])
        else
          next if hours[n] == ''
          create_time_entry(args, n)
        end
      end
    end

    def create_time_entry(args, index)
      time_entry = TimeEntry.new
      time_entry.employee_id = args[:employee_id]
      time_entry.project_id = args[:project_id]
      time_entry.hours = args[:hours][index]
      time_entry.date = args[:dates][index]
      time_entry.save
    end

    def project_list
      if current_user.business_owner?
        @projects = Project.all
        @employees = Employee.all
      else
        @projects = current_user.employee.projects
        @employees = Employee.where("employees.parent = #{current_user.employee.id} OR employees.id = #{current_user.employee.id}")
      end
      if params[:employee_id]
        @employee = @employees.(params[:employee_id])
      else
        @employee = @employees.first
      end
      @time_entry = TimeEntry.new
    end

end
