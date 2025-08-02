class LoginsController < ApplicationController
  before_action :validate_login_params, only: [:create]

  def create
    email = params[:user_login][:email].to_s.strip.downcase
    password = params[:user_login][:password]

    account = Account.find_by(email: email)

    if account.nil?
      return render json: { errors: { email: 'This email is not registered' } }, status: :unprocessable_entity
    end

    unless account.email_verified
      return render json: { errors: { email: 'Email not verified, please verify your email' } }, status: :unprocessable_entity
    end

    unless account.authenticate(password)
      return render json: { errors: { password: 'Incorrect password, please enter correct password' } }, status: :unauthorized
    end

    # Generate tokens
    token_expires_in = 1.day.from_now
    refresh_expires_in = 1.year.from_now
    id = account.id
    email = account.email
    full_name =  "#{account.first_name} #{account.last_name}"
    payload = {
      email: email,
      full_name: full_name,
      token_type: "access-token"
    }

    token = JsonAuthToken.encode(account.id, payload, token_expires_in)
    refresh_payload = payload.merge(token_type: "refresh-token")
    refresh_token = JsonAuthToken.encode(account.id, refresh_payload, refresh_expires_in)
    render_token_response(id, full_name, email, token, refresh_token)
  end

  def refresh
    token = extract_token_from_header
    if token.blank?
      return render json: { errors: [{ token: "Missing Authorization header" }] }, status: :unauthorized
    end

    begin
      decoded = JsonAuthToken.decode(token)

      unless decoded.type == "refresh-token"
        return render json: { errors: [{ token: "Only refresh token is allowed here." }] }, status: :unauthorized
      end

      account = Account.find_by(id: decoded.id)
      return render json: { errors: [{ account: "Invalid account" }] }, status: :unauthorized if account.nil?
      full_name =  "#{account.first_name} #{account.last_name}"
      email = account.email
      id = account.id
      access_payload = {
        email: email,
        full_name: full_name,
        token_type: "access-token"
      }

      new_access_token = JsonAuthToken.encode(account.id, access_payload, 1.day.from_now)
      
      render json: { meta: {
        account_id: id,
        email: email,
        full_name: full_name,
        access_token: bearer_token(new_access_token),
        refresh_token: bearer_token(token),
      } }
    rescue JWT::ExpiredSignature
      render json: { errors: [{ token: "Refresh token has expired" }] }, status: :unauthorized
    rescue JWT::DecodeError
      render json: { errors: [{ token: "Invalid token" }] }, status: :bad_request
    end
  end

  private

  def extract_token_from_header
    auth_header = request.headers['Authorization']
    return unless auth_header&.start_with?('Bearer-')
    auth_header.split('Bearer-').last.presence
  end

  def validate_login_params
    errors = []

    if params[:user_login].blank?
      return render json: { errors: { login: "Missing user_login params" } }, status: :unprocessable_entity
    end

    unless params[:user_login][:email].present?
      errors << { email: "Please enter email address" }
    end

    unless params[:user_login][:password].present?
      errors << { password: "Please enter password" }
    end

    if errors.any?
      render json: { errors: errors }, status: :unprocessable_entity
    end
  end

  def render_token_response(id, full_name, email, token, refresh_token)
    render json: {
      meta: {
        account_id: id,
        email: email,
        full_name: full_name,
        access_token: bearer_token(token),
        refresh_token: bearer_token(refresh_token),
      }
    }
  end
end
