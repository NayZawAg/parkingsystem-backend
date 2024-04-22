class DropRelatedFacilitiesEvents < ActiveRecord::Migration[6.1]
  def change
    drop_table :related_facilities_events, if_exists: true
  end
end
