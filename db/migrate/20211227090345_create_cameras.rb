# Create cameras
class CreateCameras < ActiveRecord::Migration[6.1]
  def change
    create_table :cameras do |t|
      t.references :location, null: false, foreign_key: true, limit: 20
      t.string :name, null: false, limit: 255
      t.boolean :in_flg, null: false, limit: 1
      t.boolean :out_flg, null: false, limit: 1
      t.string :dbx_folder_name, null: false, limit: 255
      t.datetime :dbx_acquired_at

      t.timestamps
    end
  end
end
