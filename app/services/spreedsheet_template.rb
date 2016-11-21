class SpreedsheetTemplate
  def initialize(params)
    @chart_data = params.fetch(:chart_data, [])
  end

  def draw_timesheet
    package = Axlsx::Package.new
    workbook = package.workbook
    @time_entries = TimeEntry.select('sum(hours)').where('employee_id = employees.id').to_sql
    @employees = Employee.select("id,name, (#{@time_entries}) as sum_hours")
    workbook.add_worksheet(name: 'Timesheet Report') do |sheet|
      sheet.add_row ['Employee Name', 'Hours']
      @employees.each do |st|
        if !st.sum_hours.nil?
          sheet.add_row [st.name, st.sum_hours]
        else
          sheet.add_row [st.name, 0]
        end
      end
      
      sheet.add_chart(Axlsx::LineChart, title: 'Simple 3D Line Chart') do |chart|
        chart.start_at 4, 0
        chart.end_at 20, 20
        @chart_data[:data].each do |time|
          colour = "%06x" % (rand * 0xffffff)
          chart.add_series data: time[:data], labels: @chart_data[:month], title: time[:name], color: colour
        end
        chart.catAxis.title = 'X Axis'
        chart.valAxis.title = 'Y Axis'
      end
    end
    package.serialize("#{Rails.root}/tmp/basic.xlsx")
  end

end