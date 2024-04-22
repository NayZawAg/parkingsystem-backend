# Create parking resets
class CreateParkingResets < ActiveRecord::Migration[6.1]
  def change
    create_table :parking_resets do |t|
      t.references :location, null: false, foreign_key: true
      t.integer :total_in_count, null: false, limit: 4, default: 0
      t.integer :reset_in_count, null: false, limit: 4, default: 0

      t.timestamps
    end
  end
end
