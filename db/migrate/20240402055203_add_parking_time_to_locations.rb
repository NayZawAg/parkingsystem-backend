class AddParkingTimeToLocations < ActiveRecord::Migration[6.1]
  def up
    add_column :locations, :opening_time, :time, precision: 6
    add_column :locations, :closing_time, :time, precision: 6
  end

  def down
    remove_column :locations, :opening_time, :time
    remove_column :locations, :closing_time, :time
  end
end
