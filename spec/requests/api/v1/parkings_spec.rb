require 'rails_helper'

RSpec.describe 'Api::V1::Parkings', type: :request do
  # GET all locations
  describe 'GET all locations' do
    # return 200 OK
    it 'return 200 OK' do
      # Check user authority
      authenticate('c1user01', 'password00')
      get '/api/v1/parkings/locations', headers: headers

      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:ok)
    end
  end

  # GET congestion rates of location
  describe 'GET congestion rates of location' do
    before :all do
      @client = FactoryBot.create(:client, name: 'カラヤン１')
      @location = FactoryBot.create(:location, client: @client)
    end
    # return 200 OK
    it 'return 200 OK' do
      day_type = 'business'
      get "/api/v1/parkings/#{@location.id}/congestion_rates?day_type=#{day_type}"

      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:ok)
    end

    # return 400 bad_request does not have params or mistake day_type
    it 'return 400 bad_request does not have params or mistake day_type' do
      day_type = ''
      get "/api/v1/parkings/#{@location.id}/congestion_rates?day_type=#{day_type}"

      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:bad_request)
    end

    # return 404 not found when location_id does not exist
    it 'return 404 not found when location_id does not exist' do
      # Check user authority
      authenticate('c1user01', 'password00')
      day_type = 'business'
      get "/api/v1/parkings/10000000/congestion_rates?day_type=#{day_type}", headers: headers

      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:not_found)
    end
  end

  # GET all resets
  describe 'GET all resets' do
    # return 200 OK
    it 'return 200 OK' do
      # Check user authority
      authenticate('c1user01', 'password00')
      get '/api/v1/parkings/resets', headers: headers

      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:ok)
    end

    # return 401 unauthorization does not match token
    it 'return 401 unauthorization does not match token' do
      # Check user authority
      authenticate('c1user011', 'password00')
      get '/api/v1/parkings/resets', headers: headers

      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:unauthorized)
    end
  end

  # Post reset
  describe 'Post reset' do
    before :all do
      @client = FactoryBot.create(:client, name: 'カラヤン2')
      @location = FactoryBot.create(:location, client: @client)
    end
    # return 201 OK
    it 'return 201 Created' do
      # Check user authority
      authenticate('c1user01', 'password00')
      @reset_params = {
        location_id: @location.id,
        total_in_count: 10,
        reset_in_count: 7
      }
      post '/api/v1/parkings/create_reset', headers: headers, params: @reset_params

      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:created)
    end

    # return 401 unauthorization does not match token
    it 'return 401 unauthorization does not match token' do
      # Check user authority
      authenticate('c1user011', 'password00')
      @reset_params = {
        location_id: @location.id,
        total_in_count: 10,
        reset_in_count: 7
      }
      post '/api/v1/parkings/create_reset', headers: headers, params: @reset_params

      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:unauthorized)
    end

    # return 404 not found when location_id does not exist
    it 'return 404 not found when location_id does not exist' do
      # Check user authority
      authenticate('c1user01', 'password00')
      @reset_params = {
        location_id: 10_000_000,
        total_in_count: 10,
        reset_in_count: 7
      }
      post '/api/v1/parkings/create_reset', headers: headers, params: @reset_params

      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:not_found)
    end

    # return 422 Unprocessable Entity
    context 'return 422 Unprocessable Entity' do
      before :each do
        # Check user authority
        authenticate('c1user01', 'password00')

        @reset_params = {
          location_id: 1,
          total_in_count: '',
          reset_in_count: ''
        }
      end

      # invalid required for reset params blank
      it 'invalid required for reset params blank' do
        client = FactoryBot.create(:client, name: 'カラヤン3')
        location = FactoryBot.create(:location, client: client)
        params = @reset_params
        params[:location_id] = location.id
        params[:total_in_count] = nil
        params[:reset_in_count] = nil

        post '/api/v1/parkings/create_reset', headers: headers, params: params

        utils_helper = UtilsHelper::ValidationError.new(response.body)

        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:unprocessable_entity)
        expect(utils_helper.error_type('total_in_count')).to eq('Total in count is required.')
        expect(utils_helper.error_type('reset_in_count')).to eq('Reset in count is required.')
      end
    end
  end

  # create
  describe '# create' do
    before :all do
      @location = FactoryBot.create(:location)
      @camera = FactoryBot.create(:camera, location: @location)
    end

    it 'create :created' do
      params = {
        camera_id: @camera.id,
        result: [
          in_out: 1,
          parking_time: '2023-01-24 16:03:00',
          car_area: '品川',
          car_number: 'た4215　34-60'
        ],
        apikey: 'D4kKNYJOIIuF2MN7uJrnhvrDw'
      }
      post '/api/v1/parkings', params: params

      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:created)
    end

    it 'create 404 Not Found' do
      params = {
        camera_id: 1_000_000_000,
        result: [
          in_out: 1,
          parking_time: '2023-01-24 16:03:00',
          car_area: '品川',
          car_number: 'た4215　34-60'
        ],
        apikey: 'D4kKNYJOIIuF2MN7uJrnhvrDw'
      }
      post '/api/v1/parkings', params: params

      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:not_found)
    end
  end
  # situations
  describe '# situations' do
    it 'situations 200 OK' do
      params = {
        from_date: '2020-01-01',
        to_date: '2023-12-31',
        location_name: '広島三次ワイナリー',
        page: 1,
        per_page: 10
      }
      # Check user authority
      authenticate('c1user01', 'password00')
      get '/api/v1/parkings/situations', params: params, headers: headers

      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:ok)
    end

    it 'situations 400 Bad Request' do
      # from_date = '2020-01-01'
      # to_date = '2023-12-31'
      # location_name = '広島三次ワイナリー'
      # page = 1
      # per_page = 10
      # Check user authority
      authenticate('c1user01', 'password00')
      get '/api/v1/parkings/situations', headers: headers

      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:bad_request)
    end
  end
end
