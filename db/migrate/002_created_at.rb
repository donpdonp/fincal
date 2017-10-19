class CreatedAt < ActiveRecord::Migration[5.1]
  def self.up
    add_column :values, :created_at, :datetime
  end
end
