class Setup < ActiveRecord::Migration
  def self.up
    create_table :values do |t|
      t.column :name, :string, :null => false
      t.column :amount, :decimal, :precision => 10
      t.column :date, :timestamp
      t.column :session_id, :string
    end
  end

  def self.down
    drop_table :values
  end
end

