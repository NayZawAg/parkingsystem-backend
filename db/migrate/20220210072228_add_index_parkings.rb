class AddIndexParkings < ActiveRecord::Migration[6.1]
  def change
    add_index :parkings, [:camera_id, :in_out_flg, :parking_time]
  end
end
