require 'rails_helper'
RSpec.describe 'Api::V1::Locations', type: :request do
  # index
  describe 'index' do
    # return 200 OK
    it 'return 200 OK' do
      # Check user authority
      authenticate('c1user01', 'password00')
      get '/api/v1/locations', headers: headers

      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:ok)
    end

    # return 401 Unauthorized
    it 'return 401 Unauthorized' do
      # Check user authority
      authenticate('c1user01111', 'password00')
      get '/api/v1/locations', headers: headers

      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
