require 'rails_helper'
RSpec.describe 'Api::V1::Download', type: :request do
  # Get Download data
  describe 'Get Download data' do
    before :all do
      @chatbot_data = FactoryBot.create(:chatbot_data)
      @camera = FactoryBot.create(:camera)
      @parking = FactoryBot.create(:parking, camera: @camera)
    end
    # return chatbot_data 200 OK
    it 'return chatbot_data 200 OK' do
      @download_params = {
        item_name: 'chatbot_data',
        from_date: '2023-01',
        to_date: '2023-01'
      }
      get '/api/v1/download', headers: headers, params: @download_params

      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:ok)
    end

    # return chatbot_data 200 OK
    it 'return parking_data 200 OK' do
      @download_params = {
        item_name: 'parking_data',
        from_date: '2023-01',
        to_date: '2023-01'
      }
      get '/api/v1/download', headers: headers, params: @download_params

      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:ok)
    end

    # return 400 bad_request does not have item_name params
    it 'return 400 bad_request does not have item_name params' do
      @download_params = {
        item_name: '',
        from_date: '2023-01',
        to_date: '2023-01'
      }
      get '/api/v1/download', headers: headers, params: @download_params

      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:bad_request)
    end

    # return 400 bad_request does not have from_date params
    it 'return 400 bad_request does not have from_date' do
      @download_params = {
        item_name: 'chatbot_data',
        from_date: '',
        to_date: '2023-01'
      }
      get '/api/v1/download', headers: headers, params: @download_params

      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:bad_request)
    end

    # return 400 bad_request does not have to_date params
    it 'return 400 bad_request does not have to_date' do
      @download_params = {
        item_name: 'chatbot_data',
        from_date: '2023-01',
        to_date: ''
      }
      get '/api/v1/download', headers: headers, params: @download_params

      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:bad_request)
    end
  end
end
