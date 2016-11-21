class TimesheetsService
  # collect data chart
  def initialize(params)
    @chart_data = params.fetch(:chart_data, [])
    @first_date = params.fetch(:first_date, Date.new)
    @last_date  = params.fetch(:last_date, Date.new)
  end

  def chart
    collect_data
  end

  private

  attr_reader :chart_data, :first_date, :last_date

  def collect_data
    temp = {}
    month = get_array_month(first_date.to_date, last_date.to_date )
    chart_data.each do |entry|
      constant = "#{entry.employee_id}_#{entry.project_id}"
      temp[constant] = {} if temp[constant].nil?
      unless temp[constant][entry.date.strftime('%b %y')]
        temp[constant][entry.date.strftime('%b %y')] = 0
      end
      temp[constant][entry.date.strftime('%b %y')] = temp[constant][entry.date.strftime('%b %y')] + entry.hours
    end
    month_data = define_month(temp,month)
    data_chart(month_data)
    # binding.pry
  end

  def define_month(temp, month)
    cc = []
    dd = {}
    temp.each do |key, value|
      dd[key] = [] unless dd[key]
      month.each do |e|
        parse_time = Time.at(e).strftime("%b %y")
        cc.push(parse_time)
        if value[parse_time]
          dd[key].push(value[parse_time])
        else
          dd[key].push(0)
        end
      end
    end
    result = {
      month: cc,
      data: dd
    }
    result
  end

  def data_chart(data_month)
    data = {}
    check = []
    data[:data] = []
    data[:month] = []
    chart_data.each do |entry|
      he = "#{entry.employee_id}_#{entry.project_id}"
      unless check.include?(he)
        h = {}
        h[:name] = entry.employee_name + ', ' + entry.project_name
        h[:data] = data_month[:data][he]
        check.push(entry.employee_id.to_s + "_" + entry.project_id.to_s)
        data[:data].push(h)
      end
      data[:month] = data_month[:month]
    end
    data
  end

  def get_array_month(date_from, date_to)
    date_range = date_from..date_to
    date_months = date_range.map {|d| Date.new(d.year, d.month, 1) }.uniq.map {|d| d.to_time.to_i }
    # date_months = date_range.map{|d| d.strftime "%d"}
    date_months
  end

end