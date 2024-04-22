# Create users
class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.references :client, null: false, foreign_key: true, limit: 20
      t.string :username, limit: 255, null: false
      t.string :password_digest, limit: 255, null: false
      t.boolean :active, default: true, limit: 1, null: false

      t.timestamps
    end
  end
end
