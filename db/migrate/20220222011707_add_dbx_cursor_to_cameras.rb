class AddDbxCursorToCameras < ActiveRecord::Migration[6.1]
  def change
    add_column :cameras, :dbx_cursor, :text, after: :dbx_acquired_at
  end
end
