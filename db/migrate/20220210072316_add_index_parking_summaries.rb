class AddIndexParkingSummaries < ActiveRecord::Migration[6.1]
  def change
    add_index :parking_summaries, [:client_id, :location_id, :day_type]
    add_index :parking_summaries, [:client_id, :location_id, :date, :time]
  end
end
