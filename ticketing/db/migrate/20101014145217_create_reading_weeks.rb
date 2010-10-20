class CreateReadingWeeks < ActiveRecord::Migration
  def self.up
    create_table :reading_weeks do |t|
      t.date :start_date
      t.date :end_date
      t.text :comment

      t.timestamps
    end
  end

  def self.down
    drop_table :reading_weeks
  end
end
