class AddColumnToLocations < ActiveRecord::Migration[6.1]
  def up
    add_column :locations, :camera_flag, :integer, default: 1
    add_column :locations, :crowd_level_display, :integer, default: 1
    add_column :locations, :icon_revert_flag, :integer, default: 0
    add_column :locations, :gtag_event_name, :string
    add_column :locations, :display_flag, :integer, default: 1
    add_column :locations, :outline, :string
    add_column :locations, :related_facilities_events, :string
    add_column :locations, :display_order, :integer
    add_column :locations, :created_by, :bigint
    add_column :locations, :updated_by, :bigint
  end

  def down
    remove_column :locations, :camera_flag, :integer
    remove_column :locations, :crowd_level_display, :integer
    remove_column :locations, :icon_revert_flag, :integer
    remove_column :locations, :gtag_event_name, :string
    remove_column :locations, :display_flag, :integer
    remove_column :locations, :outline, :string
    remove_column :locations, :related_facilities_events, :string
    remove_column :locations, :display_order, :integer
    remove_column :locations, :created_by, :bigint
    remove_column :locations, :updated_by, :bigint
  end
end
