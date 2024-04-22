# Create parking summaries
class CreateParkingSummaries < ActiveRecord::Migration[6.1]
  def change
    create_table :parking_summaries do |t|
      t.references :client, null: false, foreign_key: true, limit: 20
      t.references :location, null: false, foreign_key: true, limit: 20
      t.date :date, null: false
      t.time :time, null: false, precision: 6
      t.integer :day_type, null: false, limit: 4, default: 0
      t.integer :in_total, null: false, limit: 4, default: 0
      t.integer :out_total, null: false, limit: 4, default: 0

      t.timestamps
    end
  end
end
