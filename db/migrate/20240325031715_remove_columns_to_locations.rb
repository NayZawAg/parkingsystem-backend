class RemoveColumnsToLocations < ActiveRecord::Migration[6.1]  
    def change
      remove_column :locations, :crowd_level_threshold, :string
    end
end