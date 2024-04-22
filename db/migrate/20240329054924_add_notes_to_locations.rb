class AddNotesToLocations < ActiveRecord::Migration[6.1]
  def up
    add_column :locations, :notes, :string, limit: 255
  end

  def down
    remove_column :locations, :notes, :string
  end
end
