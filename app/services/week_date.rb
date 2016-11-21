# Get week date in specific week
class WeekDate
  attr_accessor :week, :year

  def initialize(args)
    @week = args.fetch(:week, current_week)
    @year = args.fetch(:year, current_year)
  end

  def begin_date
    date = Date.commercial(year.to_i, week.to_i + 1, 1)
    date.strftime('%B %d, %Y')
  end

  def end_date
    date = Date.commercial(year.to_i, week.to_i + 1, 7)
    date.strftime('%B %d, %Y')
  end

  def next_begin_date
    date = Date.commercial(year.to_i, week.to_i + 2, 1)
    date.strftime('%B %d, %Y')
  end

  def next_end_date
    date = Date.commercial(year.to_i, week.to_i + 2, 7)
    date.strftime('%B %d, %Y')
  end

  def previous_begin_date
    date = Date.commercial(year.to_i, week.to_i, 1)
    date.strftime('%B %d, %Y')
  end

  def previous_end_date
    date = Date.commercial(year.to_i, week.to_i, 7)
    date.strftime('%B %d, %Y')
  end

  def next_all_week_date
    dates = []
    1.upto(7) do |n|
      dates << Date.commercial(year.to_i, week.to_i + 2, n)
    end
    dates
  end

  def previous_all_week_date
    dates = []
    1.upto(7) do |n|
      dates << Date.commercial(year.to_i, week.to_i, n)
    end
    dates
  end

  private

  def current_week
    Date.current.strftime('%W').to_i + 1
  end

  def current_year
    Date.current.year
  end
end
