require 'rails_helper'

RSpec.describe ParkingReset, type: :model do
  before :all do
    @location = FactoryBot.create(:location)
    @c_model = FactoryBot.create(:parking_reset, location: @location)
  end

  # database crud
  describe 'database crud' do
    # create
    it 'create' do
      expect(@c_model.save).to eq(true)

      expect(ParkingReset.find(@c_model.id)).to have_attributes(
        location_id: @c_model.location_id,
        total_in_count: 1,
        reset_in_count: 1
      )
    end

    # update
    it 'update' do
      model = ParkingReset.find(@c_model.id)
      model.total_in_count = 2
      model.reset_in_count = 2

      expect(model.save).to eq(true)
      expect(ParkingReset.find(@c_model.id)).to have_attributes(
        total_in_count: 2,
        reset_in_count: 2
      )
    end

    # delete
    it 'delete' do
      model = ParkingReset.find(@c_model.id)
      m = model.destroy

      expect(m.total_in_count).to eq(2)
      expect(ParkingReset.where(id: @c_model.id).count).to eq(0)
    end
  end

  # validation
  describe 'validation' do
    # valid with total_in_count, reset_in_count and location_id
    it 'valid with total_in_count, reset_in_count and location_id' do
      model = FactoryBot.build(:parking_reset, location: @location)

      expect(model).to be_valid
    end

    # invalid required for total_in_count and reset_in_count
    it 'invalid required for total_in_count and reset_in_count' do
      model = FactoryBot.build(
        :parking_reset,
        total_in_count: nil,
        reset_in_count: nil
      )

      model.valid?([:parking_reset])

      expect(model.errors.where(:total_in_count).first.type).to eq(:blank)
      expect(model.errors.where(:reset_in_count).first.type).to eq(:blank)
      expect(model.save).to eq(false)
    end
  end
end
