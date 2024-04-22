# Create parkings
class CreateParkings < ActiveRecord::Migration[6.1]
  def change
    create_table :parkings do |t|
      t.references :camera, null: false, foreign_key: true, limit: 20
      t.boolean :in_out_flg, null: false, limit: 1
      t.datetime :parking_time, null: false
      t.string :car_area, limit: 255
      t.string :car_number, limit: 255

      t.timestamps
    end
  end
end
