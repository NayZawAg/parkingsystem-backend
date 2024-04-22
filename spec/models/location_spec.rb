require 'rails_helper'

RSpec.describe Location, type: :model do
  before :all do
    @client = FactoryBot.create(:client)
    @c_model = FactoryBot.create(:location, client: @client)
  end

  # database crud
  describe 'database crud' do
    # create
    it 'create' do
      expect(@c_model.save).to eq(true)

      expect(Location.find(@c_model.id)).to have_attributes(
        client_id: @c_model.client_id,
        name: '広島三次ワイナリー',
        address: '広島県三次市東酒屋町10445-3'
      )
    end

    # update
    it 'update' do
      model = Location.find(@c_model.id)
      model.name = 'トレッタみよし'

      expect(model.save).to eq(true)
      expect(Location.find(@c_model.id)).to have_attributes(
        name: 'トレッタみよし'
      )
    end

    # delete
    it 'delete' do
      model = Location.find(@c_model.id)
      m = model.destroy

      expect(m.name).to eq('トレッタみよし')
      expect(Location.where(id: @c_model.id).count).to eq(0)
    end
  end

  # validation
  describe 'validation' do
    # valid with name, address, lat, lng, image, capacity, start_time, end_time and client_id
    it 'valid with name, address, lat, lng, image, capacity, start_time, end_time and client_id' do
      model = FactoryBot.build(:location, client: @client)

      expect(model).to be_valid
    end
  end

  # def
  describe '# def' do
    it 'search_with_cameras_locations' do
      value = Location.search_with_cameras_locations
      expect(value).to match_array(value)
    end

    it 'search_with_cameras_resets' do
      value = Location.search_with_cameras_resets
      expect(value).to match_array(value)
    end
  end
end
