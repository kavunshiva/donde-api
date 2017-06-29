class Api::V1::UserDevicesController < ApplicationController
  def index
    devices = Device.where(user_id: params[:id])
    render json: devices
  end
end
