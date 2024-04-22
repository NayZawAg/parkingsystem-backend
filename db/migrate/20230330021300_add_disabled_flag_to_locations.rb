class AddDisabledFlagToLocations < ActiveRecord::Migration[6.1]
  def change
    add_column :locations, :disabled_flag, :boolean, null: false, default: 0
  end
end
