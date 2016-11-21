class DriveDrawSheet
  attr_reader :session, :data

  def initialize(session, data = {})
    @session = session
    @data = data
  end

  def call
    draw_sheet
  end

  private

  def time_entries
    TimeEntry.data_report_time_entries(data[:project])
  end

  def draw_sheet
    work = session.spreadsheet_by_key(data[:id]).worksheets[0]
    work[1, 1] = "Time Entries Report for : #{Date::MONTHNAMES[data[:month].to_i]} #{data[:year]}"
    x = 1
    y = 2
    work[y, x] = 'Date'
    x += 1
    time_entries[:sheet_data].each do |sheet_data|
      work[y, x] = sheet_data
      x += 1
    end
    # Body
    y += 1
    first_date = Date.new(data[:year].to_i, data[:month].to_i, 1)
    last_date = Date.new(data[:year].to_i, data[:month].to_i, -1)
    range_date = get_array_month(first_date, last_date)
    range_date.each do |date|
      if date <= Time.now.to_i
        x = 1
        work[y, x] = Time.at(date).strftime('%Y-%m-%d')
        x += 1
        data_time = time_entries[:time_entries]
          .select { |time_entries| time_entries.date.to_time.to_i == date }
        rows = JSON.parse data_time.to_json
        if rows.count > 0
          rows.each do |row|
            row.each do |key, value|
              if key != 'date' && key != 'id'
                work[y, x] = value.to_i
                x += 1
              end
            end
          end
        else
          time_entries[:project].each do ||
            work[y, x] = 0
            x += 1
          end
        end
        y += 1
      else
        x = 1
        work[y, x] = ''#Time.at(date).strftime('%Y-%m-%d')
        x += 1
      end
    end
    work.save
  end

  def get_array_month(date_from, date_to)
    date_range = date_from..date_to
    date_months = date_range.map { |d| Date.new(d.year, d.month, d.day) }.uniq.map { |d| d.to_time.to_i }
    date_months
  end
end
