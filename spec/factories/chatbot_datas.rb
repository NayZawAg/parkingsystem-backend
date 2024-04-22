FactoryBot.define do
  factory :chatbot_data do
    conversation_at { '2023-01-13 10:18:38' }
    user_id { '229541799' }
    conversation_id { '42551034' }
    message { '' }
    button { '対象外' }
    question_category_one { '対象外' }
    question_category_two { '対象外' }
    question_category_three { '対象外' }
    reply { false }
    language { 'zh-TW' }
    area { '三次市エリア' }
    country { '日本' }
    residential_area { '沖繩' }
    user_interface { 'LINE' }
  end
end
