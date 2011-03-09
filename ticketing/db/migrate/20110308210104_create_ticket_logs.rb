class CreateTicketLogs < ActiveRecord::Migration
  def self.up
    create_table :ticket_logs do |t|
      t.string :log
			t.integer :user_id
      t.references :ticket

      t.timestamps
    end
  end

  def self.down
    drop_table :ticket_logs
  end
end
