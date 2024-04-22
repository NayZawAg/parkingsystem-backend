class CreateFacilitiesEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :facilities_events do |t|
      t.references :client, null: false, foreign_key: true, limit: 20
      t.string :slug, limit: 255, null: false
      t.decimal :scale, precision: 3, scale: 1
      t.string :name, limit: 255, null: false
      t.string :address, limit: 255
      t.string :opening_hours, limit: 255
      t.string :phone_number, limit: 255
      t.string :available_payment, limit: 255
      t.string :offical_url, limit: 255
      t.decimal :lat, precision: 10, scale: 7
      t.decimal :lng, precision: 10, scale: 7
      t.string :image
      t.integer :disabled_flag, default: 0
      t.integer :icon_revert_flag, default: 0
      t.string :gtag_event_name, limit: 255
      t.integer :display_flag, default: 1
      t.string :outline, limit: 255
      t.integer :facility_event_type, default: 1
      t.integer :display_order, default: 0
      t.bigint :created_by
      t.bigint :updated_by

      t.timestamps
    end
  end
end
