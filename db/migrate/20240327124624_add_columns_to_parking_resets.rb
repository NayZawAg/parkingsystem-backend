class AddColumnsToParkingResets < ActiveRecord::Migration[6.1]
  def up
    add_column :parking_resets, :created_by, :bigint
    add_column :parking_resets, :updated_by, :bigint
  end

  def down
    remove_column :parking_resets, :created_by, :bigint
    remove_column :parking_resets, :updated_by, :bigint
  end
end
