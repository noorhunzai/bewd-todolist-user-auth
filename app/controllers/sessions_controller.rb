class SessionsController < ApplicationController
  def create
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session = Session.create(user: user, token: SecureRandom.hex(20))
      render json: { success: true, session_token: session.token }
    else
      render json: { success: false }
    end
  end

  def authenticated
    if current_user
      render json: { authenticated: true, username: current_user.username }
    else
      render json: { authenticated: false, username: nil }
    end
  end

  def destroy
    session = Session.find_by(token: params[:session_token])
    if session
      session.destroy
      render json: { success: true }
    else
      render json: { success: false }
    end
  end

  private

  def current_user
    session = Session.find_by(token: params[:session_token])
    session&.user
  end
end

