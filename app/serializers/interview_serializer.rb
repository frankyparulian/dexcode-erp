class InterviewSerializer < ActiveModel::Serializer
  has_one :company
  attributes :id, :name, :email, :schedule, :state, :company_id, :created_at, :updated_at
end
