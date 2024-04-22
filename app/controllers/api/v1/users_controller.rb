module Api
  module V1
    # User controller
    class UsersController < ApplicationController
      before_action :authenticate, only: [:show, :destroy]
      before_action :set_client, only: [:create]

      def create
        user = User.create!(user_params)
        render json: user.as_json(only: [:id, :username]), status: :created
      rescue ActiveRecord::RecordInvalid => e
        Rails.logger.error(e)
        render_unprocessable_entity(e)
      rescue ActiveRecord::RecordNotFound => e
        Rails.logger.debug(e)
        render_not_found(CONSTANTS::ERR_NOT_FOUND)
      rescue StandardError => e
        Rails.logger.error(e)
        render_internal_server_error(e)
      end

      def login
        user = User.find_by(username: params[:username], active: true)
        if user&.authenticate(params[:password])
          token_expired_at = 1.week.from_now
          jwt_token = encode(user.id, token_expired_at)

          render json: {
            username: user[:username],
            usertype: user[:user_type],
            token: jwt_token,
            token_expired_at: token_expired_at
          }, status: :ok
        else
          render_unauthorized(CONSTANTS::ERR_LOGIN_FAILED)
        end
      rescue BCrypt::Errors::InvalidHash
        Rails.logger.debug('Password invalid hash')
        render_unauthorized(CONSTANTS::ERR_LOGIN_FAILED)
      rescue StandardError => e
        Rails.logger.error(e)
        render_internal_server_error(e)
      end

      def show
        render json: @current_user.as_json(only: [:id, :username, :user_type])
      rescue StandardError => e
        Rails.logger.error(e)
        render_internal_server_error(e)
      end

      def destroy
        render json: {}, status: :no_content
      rescue StandardError => e
        Rails.logger.error(e)
        render_internal_server_error(e)
      end

      private

      def user_params
        params.permit(:username, :client_id, :password, :password_confirmation)
      end

      def set_client
        @client = Client.find(user_params[:client_id])
      rescue ActiveRecord::RecordNotFound => e
        Rails.logger.debug(e)
        render_not_found(CONSTANTS::ERR_NOT_FOUND)
      rescue StandardError => e
        Rails.logger.error(e)
        render_internal_server_error(e)
      end
    end
  end
end
