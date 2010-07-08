class CreateBlackouts < ActiveRecord::Migration
  def self.up
    create_table :blackouts do |t|
      t.datetime :start
      t.datetime :expiry
      t.text :comment

      t.timestamps
    end
  end

  def self.down
    drop_table :blackouts
  end
end
