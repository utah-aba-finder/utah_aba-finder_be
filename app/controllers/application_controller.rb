class ApplicationController < ActionController::API
  before_action :handle_swagger_request
  rescue_from ArgumentError, with: :handle_argument_error

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:provider_id, :role])
  end

  private

  def handle_swagger_request
    # For use when localhost is set up on API repo
    # Skip in development or for localhost requests
    # return if Rails.env.development? || request.host == 'localhost'

    # Check if this is a request from Swagger UI
    return unless from_swagger_ui?

    # Only intercept write operations
    if ['POST', 'PUT', 'PATCH', 'DELETE'].include?(request.method_symbol.to_s.upcase)
      render json: {
        status: 'test_mode',
        message: 'This is a test mode response. No changes were made to the database.',
        note: 'Please refer to the API documentation examples to see the expected response format.',
        request_details: {
          method: request.method,
          path: request.path,
          params: filtered_params
        }
      }, status: :ok
    end
  end

  def from_swagger_ui?
    return true if request.headers['Referer']&.include?('api-docs') ||
                   request.headers['Referer']&.include?('swagger') ||
                   request.headers['Origin']&.include?('api-docs') ||
                   request.headers['Origin']&.include?('swagger')
  end

  def filtered_params
    # Filter out sensitive data from the params
    params.to_unsafe_h.except(
      'controller', 
      'action', 
      'password', 
      'token', 
      'api_key'
    )
  end

  # error handling 
  def handle_argument_error(exception)
    render json: {
      status: {
        code: 422,
        message: "Invalid argument provided",
        errors: [exception.message]
      }
    }, status: :unprocessable_entity
  end
end
