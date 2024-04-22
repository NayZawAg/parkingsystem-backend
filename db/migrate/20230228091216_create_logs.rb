class CreateLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :logs do |t|
      t.references :user, null: true, foreign_key: true
      t.string :type, limit: 255
      t.string :content, limit: 255

      t.timestamps
    end
  end
end
