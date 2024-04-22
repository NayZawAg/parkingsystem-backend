class CreateUserAuthorities < ActiveRecord::Migration[6.1]
  def change
    create_table :user_authorities do |t|
      t.references :facilities_event, foreign_key: true, limit: 20
      t.references :location, foreign_key: true, limit: 20
      t.references :user, null: false, foreign_key: true, limit: 20
      t.string :authority, limit: 255

      t.timestamps
    end
  end
end
