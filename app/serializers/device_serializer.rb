class DeviceSerializer < ActiveModel::Serializer
  attributes :id, :device_name, :user_id
end
