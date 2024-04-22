class AddFacilityEventNumberToFacilitiesEvents < ActiveRecord::Migration[6.1]
  def up
    add_column :facilities_events, :facilitiy_event_number, :integer, null: false, default: 0
  end

  def down
    remove_column :facilities_events, :facilitiy_event_number, :integer
  end
end
