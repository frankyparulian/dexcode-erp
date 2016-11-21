# Calculating week hours
class WeekHours
  attr_reader :employee_id, :project_id, :week, :year

  def initialize(args)
    @employee_id = args[:employee_id]
    @project_id = args[:project_id]
    @week = args[:week]
    @year = args[:year]
  end

  def calculate
    dates = week_dates(week: week, year: year)
    time_entries = TimeEntry.where(
      employee_id: employee_id,
      project_id: project_id, date: dates)
    get_hours(time_entries: time_entries, dates: dates)
  end

  private

  def get_hours(args)
    time_entries = args[:time_entries]
    dates = args[:dates]
    hours = []
    0.upto(6) do |n|
      time_entry = time_entries.find_by(date: dates[n])
      hours << (time_entry ? time_entry.hours : '')
    end
    hours
  end

  def week_dates(args)
    week = args.fetch(:week, current_week_of_year).to_i
    year = args.fetch(:year, current_year).to_i
    dates = []
    date = Date.commercial(year, week + 1, 1)
    0.upto(6) do |n|
      dates << date + n
    end
    dates
  end

  def current_week_of_year
    Date.current.strftime('%W').to_i
  end

  def current_year
    Date.current.year
  end
end
