class Api::V1::AuthController < ApplicationController
  def create
    if params[:auth].include?(:username)
      byebug
    elsif params[:auth].include?(:device_name)
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
    else
      render json: [{}], status: 404
    end
  end
end
