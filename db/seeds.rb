require 'json'
require 'date'
# require 'pry'

user_one = User.create(
  username: "isaac",
  password: "verysecure",
  password_confirmation: "verysecure"
)

device_one = Device.create(
  device_name: "fido",
  password: "iamdog",
  password_confirmation: "iamdog",
  user_id: user_one.id
)

coords = [
  [40.717989,-74.0146443],
  [40.724299,-74.0127498],
  [40.731408,-74.0127797],
  [40.737489,-74.0123427],
  [40.742485,-74.0081954]
]

start_time = "2017-06-27 16:05:53".to_datetime

positions = []

coords.each_with_index do |c, i|
  position = Position.new(
    lat: c.first,
    long: c.last,
    alt: 5,
    time: start_time + i.minutes + (Random.rand()*60).to_i.seconds,
    prev_pos: i > 0 ? positions[i - 1].id : nil,
    next_pos: nil,
    device_id: device_one.id
  )
  position.save
  positions << position
  if i > 0
    positions[i - 1].next_pos = position.id
    positions[i - 1].save
  end
end

def json_file_to_hash(filename)
  JSON.parse(File.read(filename))
end

def get_entries_with_activity(locations)
  locations_with_activity = locations.select do |location|
    location.keys.include?('activity')
  end
end

def biking?(activity)
  activity.each do |activity|
    activity['activity'].each do |a|
      if a['type'] == 'ON_BICYCLE' && a['confidence'] > 50
        return true
      end
    end
  end
  false
end

def get_bike_positions(active_locations)
  active_locations.select do |location|
    biking?(location['activity'])
  end[0...-1]
end

def update_last_pos(current_pos, device)
  last_pos = Position.where(device_id: device.id).order(time: :desc).second
  if last_pos
    last_pos.next_pos = current_pos.id
    last_pos.save
  end
end

def seed_bike_positions(positions, device_names, user_id)
  device_name_index = 0
  device = Device.find_or_create_by(device_name: device_names[0])
  last_time = Time.at(0).to_datetime

  positions.each do |position|
    latitude, longitude, altitude, time =
      position['latitudeE7'].to_f/10000000,
      position['longitudeE7'].to_f/10000000,
      position['altitude'],
      Time.at(position['timestampMs'].to_i/1000).to_datetime

    if (time - last_time > 0.1)
      device = Device.find_by(device_name: device_names[device_name_index])
      if !device
        device = Device.create(device_name: device_names[device_name_index], password: "password", password_confirmation: "password", user_id: user_id)
      end
      device_name_index += 1
      device_name_index = device_name_index % 12
    end

    position = Position.new(
      lat: latitude,
      long: longitude,
      alt: altitude,
      time: time,
      device_id: device.id
    )
    prev_pos = Position.where(device_id: device.id).order(time: :desc).first
    if prev_pos
      position.prev_pos = prev_pos.id
    end
    if position.save
      update_last_pos(position, device)
    end
  end
end

device_names = [
  'Alpha',
  'Bravo',
  'Charlie',
  'Delta',
  'Echo',
  'Foxtrot',
  'Golf',
  'Hotel',
  'India',
  'Juliett',
  'Kilo',
  'Lima'
]

locations_hash = json_file_to_hash('db/sample10e5.json')
active_locations = get_entries_with_activity(locations_hash)
bike_positions = get_bike_positions(active_locations)
seed_bike_positions(bike_positions, device_names, user_one.id)
