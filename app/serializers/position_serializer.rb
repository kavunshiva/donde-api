class PositionSerializer < ActiveModel::Serializer
  attributes :id, :lat, :long, :alt, :time, :prev_pos, :next_pos, :device_id
end
