class Api::V1::DevicePositionsController < ApplicationController
  def index
    positions = Position.where(device_id: params[:id]).order(time: :desc)
    render json: positions
  end
end
