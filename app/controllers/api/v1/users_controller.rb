class Api::V1::UsersController < ApplicationController
  before_action :authorize_user!, except: :create
  # add this if admin feature created
  # def index
  #   users = User.all
  #   render json: users
  # end

  def create
    user = User.new(user_params)
    if user.save
      render json: user
    else
      render json: [{}], status: 404
    end
  end

  def show
    user = User.find_by(id: params[:id])
    if user
      render json: user
    else
      render_error
    end
  end

  def update
    user = User.find_by(id: params[:id])
    if user
      user.update(user_params)
      if user.save
        render json: user
      else
        render_error
      end
    else
      render_error
    end
  end

  def destroy
    user = User.find_by(id: params[:id])
    if user.destroy
      render json: user
    else
      render_error
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :username,
      :password,
      :password_confirmation
    )
  end
end
