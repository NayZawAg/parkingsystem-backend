class CreateRelatedFacilitiesEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :related_facilities_events do |t|
      t.references :location, null: false, foreign_key: true, limit: 20
      t.references :facilities_event, null: false, foreign_key: true, limit: 20

      t.timestamps
    end
  end
end
