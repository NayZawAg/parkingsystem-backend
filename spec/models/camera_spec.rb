require 'rails_helper'

RSpec.describe Camera, type: :model do
  before :all do
    @location = FactoryBot.create(:location)
    @c_model = FactoryBot.create(:camera, location: @location)
  end

  # database crud
  describe 'database crud' do
    # create
    it 'create' do
      expect(@c_model.save).to eq(true)

      expect(Camera.find(@c_model.id)).to have_attributes(
        location_id: @c_model.location_id,
        name: '入口',
        in_flg: true,
        out_flg: false
      )
    end

    # update
    it 'update' do
      model = Camera.find(@c_model.id)
      model.name = '出口'
      model.in_flg = false
      model.out_flg = true

      expect(model.save).to eq(true)
      expect(Camera.find(@c_model.id)).to have_attributes(
        name: '出口',
        in_flg: false,
        out_flg: true
      )
    end

    # delete
    it 'delete' do
      model = Camera.find(@c_model.id)
      m = model.destroy

      expect(m.name).to eq('出口')
      expect(Camera.where(id: @c_model.id).count).to eq(0)
    end
  end

  # validation
  describe 'validation' do
    # valid with name, in_flg, out_flg, dbx_folder_name, dbx_acquired_at and location_id
    it 'valid with name, in_flg, out_flg, dbx_folder_name, dbx_acquired_at and location_id' do
      model = FactoryBot.build(:camera, location: @location)

      expect(model).to be_valid
    end
  end

  # scope
  describe '# scope' do
    # with_locations
    it 'scope with_locations' do
      value = Camera.with_locations.exists?
      expect(value).to eq(true)
    end
  end
end
