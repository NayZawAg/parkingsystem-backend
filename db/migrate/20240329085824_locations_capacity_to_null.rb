class LocationsCapacityToNull < ActiveRecord::Migration[6.1]
  def up
    change_column_null :locations, :capacity, true
    change_column_null :locations, :capacity_calculation, true
  end

  def down
    change_column_null :locations, :capacity, false
    change_column_null :locations, :capacity_calculation, false
  end
end
