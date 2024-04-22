class RemoveOutlineFromLocations < ActiveRecord::Migration[6.1]
  def up
    remove_column :locations, :outline, :string
  end

  def down
    add_column :locations, :outline, :string
  end
end
