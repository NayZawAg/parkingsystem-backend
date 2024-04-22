# Create locations
class CreateLocations < ActiveRecord::Migration[6.1]
  def change
    create_table :locations do |t|
      t.references :client, null: false, foreign_key: true, limit: 20
      t.string :name, limit: 255, null: false
      t.string :address, limit: 255
      t.decimal :lat, precision: 10, scale: 7
      t.decimal :lng, precision: 10, scale: 7
      t.string :image
      t.integer :capacity, null: false, limit: 4
      t.time :start_time, precision: 6
      t.time :end_time, precision: 6

      t.timestamps
    end
  end
end
