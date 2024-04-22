json.out_count @in_out_count[:out_count] unless @meta.nil?
json.in_count @in_out_count[:in_count] unless @meta.nil?
json.results do
  json.array! @paginated_parkings.each do |parking|
    camera = parking.camera
    # parkings
    json.id parking.id
    json.in_out_flg parking.in_out_flg
    json.parking_time parking.parking_time.strftime('%Y-%m-%d %H:%M:%S')
    json.car_number parking.car_number
    json.car_area parking.car_area
    json.camera_id camera.id
    json.camera_name camera.name
  end
end
# meta
json.meta @meta unless @meta.nil?
