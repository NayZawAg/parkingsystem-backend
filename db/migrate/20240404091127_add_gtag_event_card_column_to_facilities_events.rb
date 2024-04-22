class AddGtagEventCardColumnToFacilitiesEvents < ActiveRecord::Migration[6.1]
  def up
    add_column :facilities_events, :gtag_event_card_name, :string, limit: 255 
  end

  def down
    remove_column :facilities_events, :gtag_event_card_name, :string
  end
end
