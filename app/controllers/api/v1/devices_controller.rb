class Api::V1::DevicesController < ApplicationController
  before_action :authorize_user!

  def index
    devices = Device.where(user_id: current_device.id)
    render json: devices
  end

  def create
    device = Device.new(device_params)
    if device.save
      render json: device
    else
      render_error
    end
  end

  def show
    device = Device.find_by(id: params[:id])
    if device
      render json: device
    else
      render_error
    end
  end

  def update
    device = Device.find_by(id: params[:id])
    if device
      device.update(device_params)
      if device.save
        render json: device
      else
        render_error
      end
    else
      render_error
    end
  end

  def destroy
    device = Device.find_by(id: params[:id])
    if device.destroy
      render json: device
    else
      render_error
    end
  end

  private

  def device_params
    params.require(:device).permit(:device_name, :password, :password_confirmation, :user_id)
  end

  def render_error
    render json: [{}], status: 404
  end
end
