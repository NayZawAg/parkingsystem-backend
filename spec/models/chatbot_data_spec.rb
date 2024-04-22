require 'rails_helper'

RSpec.describe ChatbotData, type: :model do
  # database crud
  describe 'database crud' do
    before :all do
      @c_model = FactoryBot.create(:chatbot_data)
    end

    # create
    it 'create' do
      expect(@c_model.save).to eq(true)
      expect(ChatbotData.find(@c_model.id)).to have_attributes(
        conversation_at: @c_model.conversation_at,
        user_id: @c_model.user_id,
        conversation_id: @c_model.conversation_id,
        message: @c_model.message,
        button: @c_model.button,
        question_category_one: @c_model.question_category_one,
        question_category_two: @c_model.question_category_two,
        question_category_three: @c_model.question_category_three,
        reply: @c_model.reply,
        language: @c_model.language,
        area: @c_model.area,
        country: @c_model.country,
        residential_area: @c_model.residential_area,
        user_interface: @c_model.user_interface
      )
    end

    # update
    it 'update' do
      model = ChatbotData.find(@c_model.id)
      model.language = 'ja'

      expect(model.save).to eq(true)
      expect(ChatbotData.find(@c_model.id)).to have_attributes(
        language: 'ja'
      )
    end

    # delete
    it 'delete' do
      model = ChatbotData.find(@c_model.id)
      m = model.destroy

      expect(m.user_id).to eq('229541799')
      expect(ChatbotData.where(id: @c_model.id).count).to eq(0)
    end
  end

  # validation
  describe 'validation' do
    # valid with chatbot_data
    it 'valid with chatbot_data' do
      model = FactoryBot.build(:chatbot_data)

      expect(model).to be_valid
    end
  end
end
