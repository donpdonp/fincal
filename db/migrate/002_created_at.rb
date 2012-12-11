class CreatedAt < ActiveRecord::Migration
  def self.up
    add_column :values, :created_at, :datetime
  end
end
