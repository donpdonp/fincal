class Value < ActiveRecord::Base
  validates :amount, :session_id, :presence => true
end

