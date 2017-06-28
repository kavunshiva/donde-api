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
