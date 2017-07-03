class Api::V1::AuthController < ApplicationController
  def create
    if params[:auth].include?(:username)
      create_user
    elsif params[:auth].include?(:device_name)
      create_device
    else
      render json: [{}], status: 404
    end
  end

  def create_device
    device = Device.find_by(device_name: params[:device_name])
    if device.present? && device.authenticate(params[:password])
      render json: {
        id: device.id,
        device_name: device.device_name,
        jwt: JWT.encode({device_id: device.id}, ENV['JWT_SECRET'], ENV['JWT_ALGORITHM'])
      }
    else
      render json: [{}], status: 404
    end
  end

  def create_user
    user = User.find_by(username: params[:username])
    if user.present? && user.authenticate(params[:password])
      render json: {
        id: user.id,
        username: user.username,
        jwt: JWT.encode({user_id: user.id}, ENV['JWT_SECRET'], ENV['JWT_ALGORITHM'])
      }
    else
      render json: [{}], status: 404
    end
  end

  def show_device
    if current_device
      render json: {
        id: current_device.id,
        device_name: current_device.device_name
      }
    else
      render json: [{}], status: 404
    end
  end

  def show_user
    if current_user
      render json: {
        id: current_user.id,
        username: current_user.username
      }
    else
      render json: [{}], status: 404
    end
  end
end
