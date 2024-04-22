require 'active_support/concern'

# Http status
module HttpStatus
  extend ActiveSupport::Concern

  # 400 bad_request
  def render_bad_request
    render json: { errors: [CONSTANTS::ERR_BAD_REQUEST] }, status: :bad_request
  end

  # 401 unauthorized
  def render_unauthorized(exception)
    render json: { errors: [exception] }, status: :unauthorized
  end

  # 404 not_found
  def render_not_found(exception)
    render json: { errors: [exception] }, status: :not_found
  end

  # 422 unprocessable entity
  def render_unprocessable_entity(exception)
    render json: { errors: exception.record.errors.full_messages }, status: :unprocessable_entity
  end

  # 500 internal_server_error
  def render_internal_server_error(exception)
    render json: { errors: [exception] }, status: :internal_server_error
  end
end
