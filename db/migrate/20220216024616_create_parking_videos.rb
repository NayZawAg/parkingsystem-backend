class CreateParkingVideos < ActiveRecord::Migration[6.1]
  def change
    create_table :parking_videos do |t|
      t.references :camera, null: false, foreign_key: true
      t.string :path, null: false
      t.datetime :captured_time, null: false
      t.boolean :analyzed, default: false, null: false

      t.timestamps
    end

    add_index :parking_videos, :captured_time
    add_index :parking_videos, :analyzed
  end
end
