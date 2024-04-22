require 'rails_helper'

RSpec.describe Client, type: :model do
  # database crud
  describe 'database crud' do
    before :all do
      @c_model = FactoryBot.create(:client)
    end

    # create
    it 'create' do
      expect(@c_model.save).to eq(true)
      expect(Client.find(@c_model.id)).to have_attributes(
        name: @c_model.name
      )
    end

    # update
    it 'update' do
      model = Client.find(@c_model.id)
      model.name = 'client1'

      expect(model.save).to eq(true)
      expect(Client.find(@c_model.id)).to have_attributes(
        name: 'client1'
      )
    end

    # # delete
    it 'delete' do
      model = Client.find(@c_model.id)
      m = model.destroy

      expect(m.name).to eq('client1')
      expect(Client.where(id: @c_model.id).count).to eq(0)
    end
  end

  # validation
  describe 'validation' do
    # valid with name
    it 'valid with name' do
      model = FactoryBot.build(:client)

      expect(model).to be_valid
    end
  end
end
