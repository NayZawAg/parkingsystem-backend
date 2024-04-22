class ChangeTotalInCountColumnOfParkingResets < ActiveRecord::Migration[6.1]
  def up
    change_column :parking_resets, :total_in_count, :decimal, precision: 13, scale: 3
    change_column :parking_resets, :reset_in_count, :decimal, precision: 13, scale: 3
  end

  def down
    change_column :parking_resets, :total_in_count, :integer
    change_column :parking_resets, :reset_in_count, :integer
  end
end
