# Create clients
class CreateClients < ActiveRecord::Migration[6.1]
  def change
    create_table :clients do |t|
      t.string :name, limit: 255, null: false

      t.timestamps
    end
  end
end
