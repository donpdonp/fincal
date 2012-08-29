class Value < ActiveRecord::Base
  validates :amount => :presence => true
end

