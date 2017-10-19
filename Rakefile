require 'bundler/setup'
require 'active_record'
require 'yaml'

task :default => [:migrate, :server]

desc "Migrate the database through scripts in db/migrate. Target specific version with VERSION=x"
task :migrate => :environment do
  ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
end

task :environment do
  ActiveRecord::Base.establish_connection(YAML::load(File.open('database.yml')))
end

desc "Start the web server"
task :server => :environment do
  require_relative "web"
  Npv.run!
end

