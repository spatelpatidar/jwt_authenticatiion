class AccountsController < ApplicationController
  def create
    query_email = account_params["email"].downcase
    account = Account.where("LOWER(email) = ?", query_email).first
    if account
      return render json: {errors: {email: "Email already Exist"}}, status: :unprocessable_entity
    end
    @account = Account.new(account_params)
    @account.email = query_email

    if @account.save
      # we can add here mailer so that user can get email and verify their email
      token = JsonAuthToken.encode(@account.id)
      render json: { account: @account, token: token }, status: :created
    else
      render json: {errors: format_activerecord_errors(@account.errors)},status: :unprocessable_entity
    end
  end

  private

  def account_params
    params.require(:account).permit(:first_name, :last_name, :email,:password, :password_confirmation)
  end
end
