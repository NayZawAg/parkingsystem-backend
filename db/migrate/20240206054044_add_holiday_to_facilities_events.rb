class AddHolidayToFacilitiesEvents < ActiveRecord::Migration[6.1]
  def up
    add_column :facilities_events, :holiday, :string
  end

  def down
    remove_column :facilities_events, :holiday, :string
  end
end
