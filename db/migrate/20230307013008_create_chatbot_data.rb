# Create chatbotData
class CreateChatbotData < ActiveRecord::Migration[6.1]
  def change
    create_table :chatbot_data do |t|
      t.datetime :conversation_at, null: false
      t.string :user_id, limit: 255, null: false
      t.string :conversation_id, limit: 255, null: false
      t.string :message, limit: 255
      t.string :button, limit: 255, null: false
      t.string :question_category_one, limit: 255, null: false
      t.string :question_category_two, limit: 255, null: false
      t.string :question_category_three, limit: 255, null: false
      t.boolean :reply, null: false, limit: 1
      t.string :language, null: false, limit: 10
      t.string :area, limit: 255, null: false
      t.string :country, limit: 255, null: false
      t.string :residential_area, limit: 255, null: false
      t.string :user_interface, null: false, limit: 255

      t.timestamps
    end
  end
end
