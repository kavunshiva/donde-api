class Api::V1::DevicesController < ApplicationController
  def index
    devices = Device.all
    render json: devices
  end

  def create
    device = Device.new(device_params)
    # fill in rest
  end

  def update
    device = Device.find_by(id: params[:id])
    # fill in rest
  end

  private

  def device_params
    params.require(:device).permit(:device_name, :password, :user_id)
  end
end
