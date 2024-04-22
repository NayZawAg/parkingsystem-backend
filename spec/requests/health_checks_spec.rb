require 'rails_helper'

RSpec.describe 'HealthChecks', type: :request do
  describe 'GET /index' do
    # return 200 OK
    it 'return 200 OK' do
      get '/health_checks'

      expect(response.content_type).to eq('text/html')
      expect(response).to have_http_status(:ok)
    end
  end
end
