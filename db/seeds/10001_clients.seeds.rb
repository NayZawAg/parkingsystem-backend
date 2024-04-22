puts 'clients, locations, cameras and users are importing.'

Support.yaml_each('client') do |definition, file_name|
  Support.benchmark(file_name) do
    # create client
    client = Client.find_or_initialize_by(name: definition[:client][:name])
    client.save!

    # create locations
    if definition[:client_locations].present?
      definition[:client_locations].each do |client_location|
        cl = Location.find_or_initialize_by(client_id: client[:id], name: client_location[:name])
        cl.assign_attributes(client_location.except(:location_cameras))
        cl.save!

        cl.update!(
          gtag_event_name: client_location[:gtag_event_name].gsub('?', cl[:id].to_s)
        )

        # create cameras
        next unless client_location[:location_cameras].present?

        client_location[:location_cameras].each do |location_camera|
          lc = Camera.find_or_initialize_by(location_id: cl[:id], name: location_camera[:name])
          lc.assign_attributes(location_camera)
          lc.save!
        end
      end
    end

    # create facility event
    if definition[:client_facilities_events].present?
      definition[:client_facilities_events].each do |client_facility_event|
        cfe = FacilitiesEvent.find_or_initialize_by(client_id: client[:id], name: client_facility_event[:name])
        cfe.assign_attributes(client_facility_event)
        cfe.save!

        cfe.update!(
          gtag_event_name: client_facility_event[:gtag_event_name].gsub('?', cfe[:id].to_s),
          gtag_event_card_name: client_facility_event[:gtag_event_card_name].gsub('?', cfe[:id].to_s)
        )
      end
    end

    # create users
    if definition[:client_users].present?
      definition[:client_users].each do |client_user|
        cu = User.find_or_initialize_by(client_id: client[:id], username: client_user[:username])
        cu.assign_attributes(client_user)
        cu.save!
      end
    end

    # create users authorites
    if definition[:client_users_authorities].present?
      definition[:client_users_authorities].each do |client_user_authority|
        cua_user = User.find_by(username: client_user_authority[:username])
        cua_facility_event = FacilitiesEvent.find_by(name: client_user_authority[:facility_event_name])
        cua_location = Location.find_by(name: client_user_authority[:location_name])

        cua_user_id = cua_user[:id]
        cua_facility_event_id = cua_facility_event[:id] if cua_facility_event.present?
        cua_location_id = cua_location[:id] if cua_location.present?

        cua = UserAuthority.find_or_initialize_by(user_id: cua_user_id, facilities_event_id: cua_facility_event_id, location_id: cua_location_id)
        cua.assign_attributes(
          user_id: cua_user_id,
          facilities_event_id: cua_facility_event_id,
          location_id: cua_location_id,
          authority: client_user_authority[:authority]
        )
        cua.save!
      end
    end
  end
end
