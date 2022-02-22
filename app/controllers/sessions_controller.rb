class SessionsController < ApplicationController
  include SessionsHelper

  def create
    user = User.find_by(email: login_params[:email].downcase)
    if user && user.authenticate(login_params[:password])
      log_in user
      flash= {:info => "Welcome back: #{user.name} :)"}
    else
      flash= {:danger => 'Wrong email or password'}
    end
    redirect_to root_url, :flash => flash
  end

  def new

  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private
  def login_params
    params.require(:session).permit(:email, :password)
  end
end
