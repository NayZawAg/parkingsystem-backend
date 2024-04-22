require 'rails_helper'

RSpec.describe Log, type: :model do
  before :all do
    @client = FactoryBot.create(:client)
    @user = FactoryBot.create(:user, client: @client, username: '田中太郎')
    @c_model = FactoryBot.create(:log, user: @user)
  end

  # database crud
  describe 'database crud' do
    # create
    it 'create' do
      expect(@c_model.save).to eq(true)
      expect(Log.find(@c_model.id)).to have_attributes(
        user_id: @user.id,
        type: @c_model.type,
        content: @c_model.content
      )
    end

    # update
    it 'update' do
      model = Log.find(@c_model.id)
      model.type = 'download_parking_data'

      expect(model.save).to eq(true)
      expect(Log.find(@c_model.id)).to have_attributes(
        type: 'download_parking_data'
      )
    end

    # delete
    it 'delete' do
      model = Log.find(@c_model.id)
      m = model.destroy

      expect(m.type).to eq('download_parking_data')
      expect(Log.where(id: @c_model.id).count).to eq(0)
    end
  end

  # validation
  describe 'validation' do
    # valid with user_id, type and content
    it 'valid with user_id, type and content' do
      model = FactoryBot.build(:log)

      expect(model).to be_valid
    end
  end
end
