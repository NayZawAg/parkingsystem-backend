class ApplicationController < ActionController::API
  # Current user
  attr_reader :current_user

  # HttpAuthentication
  include ActionController::HttpAuthentication::Token::ControllerMethods

  # HttpStatus
  include HttpStatus

  # jwt authenticator
  include JwtAuthenticator
end
