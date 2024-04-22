require 'rails_helper'

RSpec.describe Parking, type: :model do
  before :all do
    @camera = FactoryBot.create(:camera)
    @c_model = FactoryBot.create(:parking, camera: @camera)
  end

  # database crud
  describe 'database crud' do
    # create
    it 'create' do
      expect(@c_model.save).to eq(true)

      expect(Parking.find(@c_model.id)).to have_attributes(
        camera_id: @c_model.camera_id,
        in_out_flg: false,
        car_area: '横浜',
        car_number: 'あ1111 11-11'
      )
    end

    # update
    it 'update' do
      model = Parking.find(@c_model.id)
      model.in_out_flg = true
      model.parking_time = '2021-12-27 19:00:00'

      expect(model.save).to eq(true)
      expect(Parking.find(@c_model.id)).to have_attributes(
        in_out_flg: true,
        car_area: '横浜',
        car_number: 'あ1111 11-11'
      )
    end

    # # delete
    it 'delete' do
      model = Parking.find(@c_model.id)
      m = model.destroy

      expect(m.car_number).to eq('あ1111 11-11')
      expect(Parking.where(id: @c_model.id).count).to eq(0)
    end
  end

  # validation
  describe 'validation' do
    # valid with in_out_flg, parking_time, car_area, car_number and camera_id
    it 'valid with in_out_flg, parking_time, car_area, car_number and camera_id' do
      model = FactoryBot.build(:parking, camera: @camera)

      expect(model).to be_valid
    end
  end

  # scope
  describe '# scope' do
    before :all do
      @location = FactoryBot.create(:location, name: '広島三次ワイナリー')
      @camera = FactoryBot.create(:camera, location: @location)
      @parking = FactoryBot.create(:parking, camera: @camera, in_out_flg: 0)
    end

    it 'search_by_date' do
      from_date = '2020-01-01'
      to_date = '2023-01-01'
      value = Parking.search_by_date(from_date, to_date)
      expect(value).to match_array(value)
    end

    it 'search_with_in_out_flg' do
      in_out_flg = 0
      value = Parking.search_with_in_out_flg(in_out_flg)
      expect(value).to match_array(value)
    end

    it 'search_with_location_name' do
      location_name = '広島三次ワイナリー'
      value = Parking.joins(:camera).merge(Camera.joins(:location)).search_with_location_name(location_name)
      expect(value).to match_array(value)
    end
  end

  # def
  describe '# def' do
    before :all do
      @location = FactoryBot.create(:location)
      @camera = FactoryBot.create(:camera, location: @location)
    end

    it 'entry' do
      params = {
        camera_id: @camera.id,
        result: [
          {
            in_out: 0,
            parking_time: '2023-01-25 19:23:46.000',
            car_area: '横浜',
            car_number: 'か1111 11-11'
          }
        ]
      }
      value = Parking.entry(params)
      expect(value).to eq({ json: {}, status: :created })
    end

    it 'in_out_count' do
      params = {
        location_name: '広島三次ワイナリー',
        from_date: '2020-01-01',
        to_date: '2023-12-31'
      }
      value = Parking.in_out_count(params)
      expect(value).to eq({ out_count: value[:out_count], in_count: value[:in_count] })
    end

    it 'search' do
      params = {
        location_name: '広島三次ワイナリー',
        from_date: '2020-01-01',
        to_date: '2023-12-31',
        page: 1,
        per_page: 10
      }
      value = Parking.search(params)
      expect(value).to match_array(value)
    end
  end
end
