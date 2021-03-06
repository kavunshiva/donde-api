class Api::V1::PositionsController < ApplicationController
  before_action :authorize_device!

  def index
    positions = Position.where(device_id: params[:id]).order(time: :desc)
    render json: positions
  end

  def create
    position = Position.new(
      position_params(
        :lat,
        :long,
        :alt,
        :time,
        :prev_pos,
        :next_pos,
        :device_id
      )
    )
    prev_pos_list = Position.where(device_id: device_id).order(time: :desc)
    if prev_pos_list.count > 0
      position.prev_pos = prev_pos_list.first.id
    end
    if position.save
      if position.prev_pos
        update_last_pos(position)
      end
      render json: position
    else
      render json: [{}], status: 404
    end
  end

  private

  def position_params(*args)
    params.require(:position).permit(*args)
  end

  def update_last_pos(current_pos)
    last_pos = Position.where(device_id: device_id).order(time: :desc).second
    last_pos.next_pos = current_pos.id
    last_pos.save
  end

end
