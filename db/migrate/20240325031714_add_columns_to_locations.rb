class AddColumnsToLocations < ActiveRecord::Migration[6.1]
  def up
    add_column :locations, :in_parking_coefficient, :decimal, precision: 10, scale: 3
    add_column :locations, :capacity_calculation, :integer, null: false, limit: 4, default: 0
    add_column :locations, :crowd_level_threshold, :string, limit: 255
  end

  def down
    remove_column :locations, :in_parking_coefficient, :decimal
    remove_column :locations, :capacity_calculation, :integer
    remove_column :locations, :crowd_level_threshold, :string
  end
end
