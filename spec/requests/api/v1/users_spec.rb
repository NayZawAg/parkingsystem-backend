require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  # Post user
  describe 'Post user' do
    before :all do
      @client = FactoryBot.create(:client, name: 'カラヤン4')
    end
    # return 201 OK
    it 'return 201 Created' do
      @user_params = {
        username: 'c1user00',
        client_id: @client.id,
        password: 'password00',
        password_confirmation: 'password00'
      }
      post '/api/v1/users', params: @user_params
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:created)
    end

    # return 404 not found when client_id does not exist
    it 'return 404 not found when client_id does not exist' do
      @user_params = {
        username: 'c1user05',
        client_id: 100,
        password: 'password00',
        password_confirmation: 'password00'
      }
      post '/api/v1/users', params: @user_params

      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:not_found)
    end

    # return 422 Unprocessable Entity
    context 'return 422 Unprocessable Entity' do
      before :each do
        @user_params = {
          username: '',
          client_id: @client.id,
          password: '',
          password_confirmation: ''
        }
      end

      # invalid required for user params blank
      it 'invalid required for user params blank' do
        post '/api/v1/users', params: @user_params

        utils_helper = UtilsHelper::ValidationError.new(response.body)

        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:unprocessable_entity)
        expect(utils_helper.error_type('password')).to eq('Password can\'t be blank')
        expect(utils_helper.error_type('username')).to eq('Username is required.')
      end
    end
  end

  # Login user
  describe 'Login user' do
    # return 201 OK
    it 'return 200 ok' do
      @user_params = {
        username: 'c1user01',
        password: 'password00'
      }
      post '/api/v1/users/login', params: @user_params
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:ok)
    end

    # return 401 unauthorization does not match user and password
    it 'return 401 unauthorization does not match user and password' do
      @user_params = {
        username: 'c1user0100',
        password: 'password00'
      }
      post '/api/v1/users/login', params: @user_params
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:unauthorized)
    end
  end

  # Me
  describe 'show' do
    # return 201 OK
    it 'show return 200 ok' do
      # Check user authority
      authenticate('c1user01', 'password00')
      get '/api/v1/users/me', headers: headers
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:ok)
    end

    # return 401 unauthorization does not match user and password
    it 'show return 401 unauthorization does not match user and password' do
      # Check user authority
      authenticate('c1user0100', 'password00')
      get '/api/v1/users/me', headers: headers
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:unauthorized)
    end
  end

  # Me
  describe 'destroy Logout' do
    # return 204 no content
    it 'destroy return 204 no content' do
      # Check user authority
      authenticate('c1user01', 'password00')
      delete '/api/v1/users/logout', headers: headers
      expect(response).to have_http_status(:no_content)
    end

    # return 401 unauthorization does not match user and password
    it 'destroy return 401 unauthorization does not match user and password' do
      # Check user authority
      authenticate('c1user0100', 'password00')
      delete '/api/v1/users/logout', headers: headers
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
