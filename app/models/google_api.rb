# == Schema Information
#
# Table name: google_apis
#
#  id            :integer          not null, primary key
#  client_id     :text
#  client_secret :text
#  redirect_uri  :string(255)
#  access_token  :text
#  expire_in     :integer
#  id_token      :text
#  refresh_token :text
#  created_at    :datetime
#  updated_at    :datetime
#

class GoogleApi < ActiveRecord::Base
  class << self
    def save_data(data)
      if first
        first.update(data)
      else
        create(data)
      end
    end
  end
end
