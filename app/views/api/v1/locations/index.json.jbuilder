json.array! @locations.each do |location|
  json.call(
    location,
    :id,
    :name
  )
end
