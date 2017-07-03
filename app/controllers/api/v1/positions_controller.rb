class Api::V1::PositionsController < ApplicationController
  before_action :authorize_device!, only: :create

  def index
    positions = Position.all
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
    position.prev_pos = Position.where(device_id: device_id).order(time: :desc).first.id
    if position.save
      update_last_pos(position)
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
