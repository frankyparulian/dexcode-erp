# == Schema Information
#
# Table name: feedbacks
#
#  id            :integer          not null, primary key
#  gid           :string(255)
#  client_id     :integer
#  client_name   :string(255)
#  content       :string(255)
#  rating        :float
#  allow_publish :boolean
#  created_at    :datetime
#  updated_at    :datetime
#

# Store Feedback from Client
class Feedback < ActiveRecord::Base
  belongs_to :client

  validates :gid, presence: true, length: { minimum: 5, maximum: 5 }
  validates :client_id, presence: true
  validates :client_name, presence: true
  
  before_validation :set_client_name

  def generate_gid
    random_gid = generate_random_string
    feedback = Feedback.find_by(gid: random_gid)
    while feedback
      random_gid = generate_random_string
      feedback = Feedback.find_by(gid: random_gid)
    end
    random_gid
  end

  private
  
  def set_client_name
    self.client_name = self.client.name if self.client
  end

  def generate_random_string
    o = [(0..9), ('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
    (0...5).map { o[rand(o.length)] }.join
  end
end
