require 'active_support/concern'
require 'jwt'

# Jwt Authenticator
module JwtAuthenticator
  extend ActiveSupport::Concern

  SECRET_KEY_BASE = Rails.application.credentials.secret_key_base

  # authenticate
  def authenticate
    jwt_authenticate || render_unauthorized(CONSTANTS::ERR_UNAUTHORIZED)
  end

  def jwt_authenticate
    authenticate_with_http_token do |token, _options|
      begin
        payload = decode(token)
        @current_user = User.find_by(id: payload['user_id'])
      rescue JWT::VerificationError
        return false
      rescue JWT::ExpiredSignature
        return false
      rescue StandardError
        return false
      end

      return false if @current_user.blank?

      true
    end
  end

  def encode(user_id, token_expired_at)
    preload = { user_id: user_id, exp: token_expired_at.to_i }
    JWT.encode(preload, SECRET_KEY_BASE, 'HS256')
  end

  def decode(encoded_token)
    decoded_dwt = JWT.decode(encoded_token, SECRET_KEY_BASE, true, algorithm: 'HS256')
    decoded_dwt.first
  end
end
