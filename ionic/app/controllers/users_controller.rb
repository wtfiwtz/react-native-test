class UsersController < ApplicationController

  before_action :load_user, only: [:show, :upload_avatar, :update]

  def show
    authorize! :read, @user
  end

  def upload_avatar
    authorize! :update, @user
  end

  def update
    authorize! :update, @user
    @user.update_attributes(user_params)
    redirect_to user_path(@user)
  end

  private

  def load_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:avatar)
  end
end
