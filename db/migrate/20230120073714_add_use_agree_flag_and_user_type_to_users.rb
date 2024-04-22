class AddUseAgreeFlagAndUserTypeToUsers < ActiveRecord::Migration[6.1]
  def up
    add_column :users, :use_agree_flag, :boolean, null: false, default: 0
    add_column :users, :user_type, :integer, null: false, default: 0
  end

  def down
    remove_column :users, :use_agree_flag
    remove_column :users, :user_type
  end
end
