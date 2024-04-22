require 'date'

puts 'parkings are importing.'

CAR_AREAS = %w[広島 品川 横浜].freeze
CAR_CHARACTERS = %w[あ か さ た な].freeze

def generate_car_number
  "#{CAR_CHARACTERS.sample}#{rand(1000...9000)} #{rand(10...90)}-#{rand(10...90)}"
end

def all_locations
  # Location.all
  Location.where(camera_flag: 1)
end

def create_in_out_parkings(location, parking_time)
  # capacity
  capacity = location[:capacity]
  # start_time
  start_time = location[:start_time]
  # end_time
  end_time = location[:end_time]
  # date
  date = parking_time.to_formatted_s(:db)[0, 10]
  # start_datetime
  start_datetime = DateTime.parse("#{date} #{start_time}")
  # end_datetime
  end_datetime = DateTime.parse("#{date} #{end_time}")
  # datetime
  datetime = start_datetime
  # location
  location.cameras.each do |camera|
    in_minute_interval = rand(3..30)
    out_minute_interval = rand(3..40)
    # in_cars
    in_cars = []
    # create in
    capacity.times do
      # car area
      car_area = CAR_AREAS.sample
      # car number
      car_number = generate_car_number
      # parking_time
      datetime += in_minute_interval.minutes
      # fetch_datetime
      datetime = fetch_datetime(datetime, end_datetime)
      # add cars
      in_cars << {
        car_area: car_area,
        car_number: car_number,
        parking_time: datetime
      }
      # create
      Parking.create(
        camera_id: camera[:id],
        in_out_flg: false,
        parking_time: datetime,
        car_area: car_area,
        car_number: car_number
      )
    end

    # datetime
    datetime += rand(1..5).hours
    # fetch_datetime
    datetime = fetch_datetime(datetime, end_datetime)
    # create out
    in_cars.each do |in_car|
      # datetime
      datetime += out_minute_interval.minutes
      # fetch_datetime
      datetime = fetch_datetime(datetime, end_datetime)
      # create
      Parking.create(
        camera_id: camera[:id],
        in_out_flg: true,
        parking_time: datetime,
        car_area: in_car[:car_area],
        car_number: in_car[:car_number]
      )
    end
  end
end

def create_in_parkings(location, parking_time)
  # capacity
  capacity = location[:capacity]
  # start_time
  start_time = location[:start_time]
  # end_time
  end_time = location[:end_time]
  # date
  date = parking_time.to_formatted_s(:db)[0, 10]
  # start_datetime
  start_datetime = DateTime.parse("#{date} #{start_time}")
  # end_datetime
  end_datetime = DateTime.parse("#{date} #{end_time}")
  # datetime
  datetime = start_datetime
  camera_count = location.cameras.length
  empty_count = 0
  available_count = capacity / (camera_count * 2)
  full_count = capacity / camera_count
  # location
  location.cameras.each do |camera|
    in_minute_interval = rand(3..30)
    capacity_count = [empty_count, available_count, full_count].sample
    # create in
    capacity_count.times do
      # car area
      car_area = CAR_AREAS.sample
      # car number
      car_number = generate_car_number
      # parking_time
      datetime += in_minute_interval.minutes
      # fetch_datetime
      datetime = fetch_datetime(datetime, end_datetime)
      # create
      Parking.create(
        camera_id: camera[:id],
        in_out_flg: false,
        parking_time: datetime,
        car_area: car_area,
        car_number: car_number
      )
    end
  end
end

def fetch_datetime(datetime, end_datetime)
  datetime = end_datetime - 1.hours if datetime >= end_datetime
  datetime
end

def parking_main
  # get locations
  locations = all_locations
  # now
  now = Time.zone.now
  # parking_time
  parking_time = now - 2.weeks
  # create parkings
  14.times do
    # create parking
    puts "#{parking_time}: parkings are importing."
    locations.each do |location|
      create_in_out_parkings(location, parking_time)
    end
    # parking_time
    parking_time += 1.day
  end

  # parking_time
  parking_time = now
  # create parking
  puts "#{parking_time}: parkings are importing."
  locations.each do |location|
    create_in_parkings(location, parking_time)
  end
end

parking_main
