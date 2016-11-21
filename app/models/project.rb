# == Schema Information
#
# Table name: projects
#
#  id         :integer          not null, primary key
#  client_id  :integer          not null
#  name       :string(255)      not null
#  created_at :datetime
#  updated_at :datetime
#

# Store project information
class Project < ActiveRecord::Base
  validates :client_id, presence: true
  validates :name, presence: true

  belongs_to :client
  has_many :time_entries
  has_many :employee_projects
  has_many :employees, through: :employee_projects

  class << self
    def query_name_by_time_entries
      select(:name)
        .where('id = time_entries.project_id')
        .to_sql
    end
  end
end
