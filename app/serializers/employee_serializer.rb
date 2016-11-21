class EmployeeSerializer < ActiveModel::Serializer
  attributes :id, :name, :initial, :position, :salary, :salary_currency,
    :start_date, :end_date, :children

  def initial
    name.split(' ').collect { |token| token[0] }.join('').upcase
  end

  def children
    object.children
  end
end
