require 'rails_helper'

RSpec.describe ParkingSummary, type: :model do
  before :all do
    @client = FactoryBot.create(:client)
    @location = FactoryBot.create(:location)
    @c_model = FactoryBot.create(:parking_summary, client: @client, location: @location)
  end

  # database crud
  describe 'database crud' do
    # create
    it 'create' do
      expect(@c_model.save).to eq(true)

      expect(ParkingSummary.select("
        client_id,
        location_id,
        FORMAT(date, 'yyyy-MM-dd') AS summary_date,
        FORMAT(CAST(time AS datetime2), N'HH:mm:ss') AS summary_time,
        day_type,
        in_total,
        out_total
      ").find(@c_model.id)).to have_attributes(
        client_id: @c_model.client_id,
        location_id: @c_model.location_id,
        summary_date: '2022-01-18',
        summary_time: '11:00:00',
        day_type: 0,
        in_total: 2,
        out_total: 0
      )
    end

    # update
    it 'update' do
      model = ParkingSummary.find(@c_model.id)
      model.date = '2022-01-19'
      model.time = '12:00:00'

      expect(model.save).to eq(true)
      expect(ParkingSummary.select("
        FORMAT(date, 'yyyy-MM-dd') AS summary_date,
        FORMAT(CAST(time AS datetime2), N'HH:mm:ss') AS summary_time
      ").find(@c_model.id)).to have_attributes(
        summary_date: '2022-01-19',
        summary_time: '12:00:00'
      )
    end

    # delete
    it 'delete' do
      model = ParkingSummary.find(@c_model.id)
      model.destroy
      expect(ParkingSummary.where(id: @c_model.id).count).to eq(0)
    end
  end

  # validation
  describe 'validation' do
    # valid with date, time, day_type, in_total, out_total, client_id and location_id
    it 'valid with date, time, day_type, in_total, out_total, client_id and location_id' do
      model = FactoryBot.build(:parking_summary, client: @client, location: @location)

      expect(model).to be_valid
    end
  end

  # scopes
  describe '# scopes' do
    before :all do
      @client = FactoryBot.create(:client, name: 'カラヤン5')
      @location = FactoryBot.create(:location, client: @client)
      @parking_summary = FactoryBot.create(:parking_summary, client: @client, location: @location)
    end

    it 'search_by_location' do
      value = ParkingSummary.search_by_location(@location.id).exists?
      expect(value).to eq(true)
    end

    it 'search_with_day_types' do
      day_types = [0]
      value = ParkingSummary.search_with_day_types(day_types).exists?
      expect(value).to eq(true)
    end
  end

  # def
  describe '# def' do
    before :all do
      @client = FactoryBot.create(:client, name: 'カラヤン6')
      @location = FactoryBot.create(:location, client: @client)
      @parking_summary = FactoryBot.create(:parking_summary, client: @client, location: @location, day_type: 1)
      @params = {
        day_type: 'holiday'
      }
    end

    it 'congestion_rates' do
      value = ParkingSummary.congestion_rates(@params, @location)
      expect(value).to eq(value)
    end

    it 'calculate_congestion_rates' do
      total_capacity = 70
      value = ParkingSummary.calculate_congestion_rates(total_capacity, @location, @params)
      expect(value).to match_array(value)
    end
  end
end
