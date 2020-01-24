class CreateClockLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :clock_logs do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.datetime :clocked_in_at
      t.datetime :clocked_out_at

      t.timestamps
    end
  end
end
