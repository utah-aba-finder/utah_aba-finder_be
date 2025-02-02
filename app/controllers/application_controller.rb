class ApplicationController < ActionController::API
  before_action :handle_swagger_request

  private

  def handle_swagger_request
    # Check if this is a request from Swagger UI
    return unless request.headers['Origin']&.include?('swagger') || 
                  request.headers['Referer']&.include?('swagger')

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
end
