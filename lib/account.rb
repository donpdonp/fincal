#!/usr/bin/ruby

class Account < ActiveRecord::Base

  def find_latest_value
    Value.find_by_account_id(self["id"])
  end

  def principle
    find_latest_value.principle
  end

  def elapsed_seconds
    Time.now - find_latest_value.date
  end

  def present_value
    # find the latest value
    value = find_latest_value

    # calculate a year of interest
    year_interest = (self["interest"]/100) * value.principle

    value.principle + year_interest/365/24/60/60 * elapsed_seconds

  end
end


