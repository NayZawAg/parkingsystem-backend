# ChatbotData model
class ChatbotData < ApplicationRecord
  scope :search_by_date, ->(from_year_month, to_year_month) { where("FORMAT(CAST(conversation_at AS datetime), N'yyyy-MM') BETWEEN ? AND ?", from_year_month, to_year_month) }

  def self.search_chatbot_data(params)
    ChatbotData.search_by_date(params[:from_year_month], params[:to_year_month])
  end
end
