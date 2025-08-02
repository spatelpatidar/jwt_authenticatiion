class DashboardController < ApplicationController
  include JsonAuthTokenValidation
  before_action :validate_json_web_token
  before_action :authorize_user

  def index
    render json: { message: "Welcome, account #{@current_user.email}" }
  end
end
