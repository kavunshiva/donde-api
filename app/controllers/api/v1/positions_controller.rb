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
    if position.save
      render json: position
    else
      render json: [{}], status: 404
    end
  end

  private

  def position_params(*args)
    params.require(:position).permit(*args)
  end
end
