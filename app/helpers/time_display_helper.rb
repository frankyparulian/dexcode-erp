module TimeDisplayHelper
  DAYS_NAME = %w(Minggu Senin Selasa Rabu Kamis Jumat Sabtu)
  MONTHS_NAME = %w(Januari Februari Maret April Mei Juni Juli Agustus September Oktober November Desember)

  #
  # @param datetime [DateTime]
  #
  def display_interview_datetime(datetime)
    date = datetime.day
    day = DAYS_NAME[datetime.wday]
    month = MONTHS_NAME[datetime.month - 1]
    year = datetime.year
    time = datetime.strftime('%-l:00')
    zone = display_zone(datetime)

    "hari #{day} tanggal #{date} #{month} #{year} jam #{time} #{zone}"
  end

  def display_zone(datetime)
    hour = datetime.hour

    if hour < 12
      'pagi'
    elsif hour >= 12 && hour < 15
      'siang'
    elsif hour >= 15
      'sore'
    end
  end

  def display_interview_time(datetime)
    time = datetime.strftime('%-l:00')
    zone = display_zone(datetime)

    "jam #{time} #{zone}"
  end

  def display_current_begin_week
    date = Date.commercial(current_year, current_week_of_year + 1, 1)
    date.strftime('%B %d, %Y')
  end

  def display_current_end_week
    date = Date.commercial(current_year, current_week_of_year + 1, 7)
    date.strftime('%B %d, %Y')
  end

  def current_date
    Date.current
  end

  def current_week_dates
    dates = []
    date = Date.commercial(current_year, current_week_of_year + 1, 1)
    0.upto 6 do |n|
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
