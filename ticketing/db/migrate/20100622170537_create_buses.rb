class CreateBuses < ActiveRecord::Migration
  def self.up
    create_table :buses do |t|
      t.string :name
      t.string :description
      t.datetime :departure
      t.datetime :arrival
      t.datetime :return
      t.float :ticket_price
      t.text :comment
      t.string :status
      t.string :direction
      t.integer :sales_lead

      t.timestamps
    end
  end

  def self.down
    drop_table :buses
  end
end
