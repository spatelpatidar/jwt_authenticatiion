module JsonAuthTokenValidation
  ERROR_CLASSES = [
    JWT::DecodeError,
    JWT::ExpiredSignature,
  ].freeze

  private

  def validate_json_web_token
    token = extract_token_from_header
    unless token
      return render json: { errors: [token: 'Missing or malformed Authorization header'] }, status: :unauthorized
    end

    begin
      @token = JsonAuthToken.decode(token)
      if @token.respond_to?(:type) && @token.type == "refresh-token"
        return render json: { errors: { token: "Refresh token cannot be used for this request." } }, status: :unauthorized
      end

      @account = Account.find_by(id: @token.id)
    rescue *ERROR_CLASSES => exception
      handle_exception(exception)
    end
  end

  def extract_token_from_header
    auth_header = request.headers['Authorization']
    return unless auth_header&.start_with?('Bearer-')

    auth_header.split('Bearer-').last.presence
  end

  def handle_exception(exception)
    case exception
    when JWT::ExpiredSignature
      render json: { errors: [token: 'Token has expired'] }, status: :unauthorized
    when JWT::DecodeError
      render json: { errors: [token: 'Invalid token'] }, status: :bad_request
    else
      render json: { errors: [message: 'Unexpected error occurred'] }, status: :internal_server_error
    end
  end
end
