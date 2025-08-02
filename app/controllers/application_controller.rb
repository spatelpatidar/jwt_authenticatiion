class ApplicationController < ActionController::API
  include JsonAuthTokenValidation
  attr_reader :current_user

  private

  def bearer_token(token)
    "Bearer-#{token}"
  end

  def authorize_user
    @current_user = Account.find(@token.id)
  rescue ActiveRecord::RecordNotFound
    render json: { errors: { message: "Please login again." } }, status: :unprocessable_entity
  end

  def format_activerecord_errors(errors)
      result = []
        errors.each do |error|
        result << { error.attribute => error.message }
      end
      result
    end
end
