class UsersController < ApplicationController
  def create
    @user = User.new(user_params)

    if @user.save
      render 'users/create' # can be omitted
    else
      render json: { success: false }
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end
end
