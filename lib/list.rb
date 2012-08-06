#!/usr/bin/env ruby 

require 'bundler/setup'
require 'active_record'
require_relative 'value'
require_relative 'account'

ActiveRecord::Base.establish_connection(
    :adapter  => "postgresql",
    :host     => "localhost",
    :username => "rubyfinance",
    :password => "ruby00",
    :database => "finance"
    #:adapter  => "sqlite3",
    #:dbfile   => "finance.db"
  )



Account.find(:all).each do |account|
 puts "#{account.name} #{account.interest}%"
 puts "latest value #{account.principle} present value #{account.present_value}"
 growth = account.present_value - account.principle
 dps = growth * 100 / account.elapsed_seconds
 puts "$#{growth} elapsed seconds #{account.elapsed_seconds} cents per second #{dps}"
end
