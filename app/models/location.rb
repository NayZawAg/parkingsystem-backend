# Location model
class Location < ApplicationRecord
  belongs_to :client
  belongs_to :user_authorities, optional: true
  has_many :cameras, dependent: :destroy
  has_many :parking_summaries, dependent: :destroy
  has_many :parking_resets, dependent: :destroy
  validates :name, length: { maximum: 255 }, presence: true
  validates :address, length: { maximum: 255 }, if: :present_address
  validates :capacity, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 2_147_483_647 }, allow_nil: true
  validates :related_facilities_events, length: { maximum: 255 }, if: :present_related_facilities_events

  def self.search_with_cameras_locations
    today_start_time = Time.zone.today.beginning_of_day
    today_end_time = Time.zone.today.end_of_day
    max_created_reset_locations = Location.select("locations.id,
                                                   locations.name,
                                                   locations.address,
                                                   locations.lat,
                                                   locations.lng,
                                                   locations.image,
                                                   locations.capacity,
                                                   locations.capacity_calculation,
                                                   locations.disabled_flag,
                                                   locations.start_time,
                                                   locations.end_time,
                                                   locations.opening_time,
                                                   locations.closing_time,
                                                   locations.camera_flag,
                                                   locations.icon_revert_flag,
                                                   locations.gtag_event_name,
                                                   locations.display_flag,
                                                   locations.crowd_level_display,
                                                   locations.in_parking_coefficient,
                                                   STRING_AGG (cm.id, ',') WITHIN GROUP (ORDER BY cm.id) AS camera_ids,
                                                   pr.reset_in_count,
                                                   pr.created_at,
                                                   0 AS current_total_count
                                                ")
                                          .joins("LEFT OUTER JOIN cameras AS cm ON cm.location_id = locations.id
                                                  LEFT JOIN (
                                                    SELECT pr.*
                                                    FROM parking_resets AS pr
                                                    INNER JOIN (
                                                      SELECT
                                                        location_id,
                                                        MAX(created_at) AS max_created_at
                                                      FROM parking_resets
                                                      WHERE created_at BETWEEN '#{today_start_time.strftime("%Y-%m-%d %H:%M:%S")}' AND '#{today_end_time.strftime("%Y-%m-%d %H:%M:%S")}'
                                                      GROUP BY location_id
                                                    ) AS max_reset
                                                    ON pr.location_id = max_reset.location_id
                                                    AND pr.created_at = max_reset.max_created_at
                                                  ) AS pr
                                                  ON pr.location_id = locations.id
                                                ")
                                          .group("locations.id,
                                                  locations.name,
                                                  locations.address,
                                                  locations.lat,
                                                  locations.lng,
                                                  locations.image,
                                                  locations.capacity,
                                                  locations.capacity_calculation,
                                                  locations.disabled_flag,
                                                  locations.start_time,
                                                  locations.end_time,
                                                  locations.opening_time,
                                                  locations.closing_time,
                                                  locations.camera_flag,
                                                  locations.icon_revert_flag,
                                                  locations.gtag_event_name,
                                                  locations.display_flag,
                                                  locations.crowd_level_display,
                                                  locations.in_parking_coefficient,
                                                  pr.reset_in_count,
                                                  pr.created_at
                                                ")
    max_created_reset_locations.each do |location|
      target_start_time = ''
      target_start_time = location.created_at unless location.created_at.nil?
      in_parking_count = Parking.where("parkings.camera_id IN (?) AND parkings.parking_time > ?
                    AND (FORMAT(CAST(parkings.parking_time AS datetime2), N'HH:mm') >= FORMAT(CAST(? AS datetime2), N'HH:mm')
                    AND FORMAT(CAST(parkings.parking_time AS datetime2), N'HH:mm') <= FORMAT(CAST(? AS datetime2), N'HH:mm'))
                    AND in_out_flg = ?
                    AND CONVERT(nvarchar, parkings.parking_time, 23) = ?",
                    location.camera_ids, target_start_time, location.start_time, location.end_time, 0, Date.current.strftime('%Y-%m-%d')).count
      out_parking_count = Parking.where("parkings.camera_id IN (?) AND parkings.parking_time > ?
                    AND (FORMAT(CAST(parkings.parking_time AS datetime2), N'HH:mm') >= FORMAT(CAST(? AS datetime2), N'HH:mm')
                    AND FORMAT(CAST(parkings.parking_time AS datetime2), N'HH:mm') <= FORMAT(CAST(? AS datetime2), N'HH:mm'))
                    AND in_out_flg = ?
                    AND CONVERT(nvarchar, parkings.parking_time, 23) = ?",
                    location.camera_ids, target_start_time, location.start_time, location.end_time, 1, Date.current.strftime('%Y-%m-%d')).count
      if location.in_parking_coefficient.present?
        location.current_total_count = ((in_parking_count * location.in_parking_coefficient) - out_parking_count) + location.reset_in_count.to_f
      else
        location.current_total_count = (in_parking_count - out_parking_count) + location.reset_in_count.to_f
      end
      # location.current_total_count = 70
    end
  end

  def self.search_with_cameras_resets
    today_start_time = Time.zone.today.beginning_of_day
    today_end_time = Time.zone.today.end_of_day
    max_created_reset_locations = Location.select("locations.id,
                                                   locations.name,
                                                   locations.capacity,
                                                   locations.capacity_calculation,
                                                   locations.start_time,
                                                   locations.end_time,
                                                   locations.in_parking_coefficient,
                                                   STRING_AGG (cm.id, ',') WITHIN GROUP (ORDER BY cm.id) AS camera_ids,
                                                   pr.created_at AS reset_datetime,
                                                   pr.total_in_count AS total_in_count,
                                                   pr.reset_in_count AS reset_in_count,
                                                   pre_pr.created_at AS pre_reset_datetime,
                                                   pre_pr.total_in_count AS pre_total_in_count,
                                                   pre_pr.reset_in_count AS pre_reset_in_count,
                                                   0 AS current_total_in_count
                                                ")
                                          .joins("
                                                  INNER JOIN cameras AS cm ON cm.location_id = locations.id
                                                  LEFT JOIN (
                                                    SELECT pr.*
                                                    FROM parking_resets AS pr
                                                    INNER JOIN (
                                                      SELECT
                                                        location_id,
                                                        MAX(created_at) AS max_created_at
                                                      FROM parking_resets
                                                      WHERE created_at BETWEEN '#{today_start_time.strftime("%Y-%m-%d %H:%M:%S")}' AND '#{today_end_time.strftime("%Y-%m-%d %H:%M:%S")}'
                                                      GROUP BY location_id
                                                    ) AS max_reset
                                                    ON pr.location_id = max_reset.location_id
                                                    AND pr.created_at = max_reset.max_created_at
                                                  ) AS pr
                                                  ON pr.location_id = locations.id
                                                  LEFT JOIN (
                                                    SELECT pre_pr.*
                                                    FROM parking_resets AS pre_pr
                                                    INNER JOIN (
                                                      SELECT
                                                        location_id,
                                                        MAX(created_at) AS max_created_at
                                                      FROM parking_resets
                                                      GROUP BY location_id
                                                    ) AS max_reset
                                                    ON pre_pr.location_id = max_reset.location_id
                                                    AND pre_pr.created_at = max_reset.max_created_at
                                                  ) AS pre_pr
                                                  ON pre_pr.location_id = locations.id
                                                ")
                                          .group("
                                                  locations.id,
                                                  locations.name,
                                                  locations.capacity,
                                                  locations.capacity_calculation,
                                                  locations.start_time,
                                                  locations.end_time,
                                                  locations.in_parking_coefficient,
                                                  pr.total_in_count,
                                                  pr.reset_in_count,
                                                  pr.created_at,
                                                  pre_pr.total_in_count,
                                                  pre_pr.reset_in_count,
                                                  pre_pr.created_at
                                                ")
    max_created_reset_locations.each do |location|
      target_start_time = Time.zone.today.beginning_of_day
      target_start_time = location.reset_datetime unless location.reset_datetime.nil?
      in_parking_count = Parking.where("parkings.camera_id IN (?) AND parkings.parking_time > ?
                      AND (FORMAT(CAST(parkings.parking_time AS datetime2), N'HH:mm') >= FORMAT(CAST(? AS datetime2), N'HH:mm')
                      AND FORMAT(CAST(parkings.parking_time AS datetime2), N'HH:mm') <= FORMAT(CAST(? AS datetime2), N'HH:mm'))
                      AND in_out_flg = ?", location.camera_ids, target_start_time, location.start_time, location.end_time, 0).count
      out_parking_count = Parking.where("parkings.camera_id IN (?) AND parkings.parking_time > ?
                      AND (FORMAT(CAST(parkings.parking_time AS datetime2), N'HH:mm') >= FORMAT(CAST(? AS datetime2), N'HH:mm')
                      AND FORMAT(CAST(parkings.parking_time AS datetime2), N'HH:mm') <= FORMAT(CAST(? AS datetime2), N'HH:mm'))
                      AND in_out_flg = ?", location.camera_ids, target_start_time, location.start_time, location.end_time, 1).count
      # location.current_total_in_count = location.reset_in_count && location.reset_in_count.to_i > 0 ? location.reset_in_count + (in_parking_count - out_parking_count) : in_parking_count - out_parking_count
      if location.in_parking_coefficient.present?
        location.current_total_in_count = ((in_parking_count * location.in_parking_coefficient) - out_parking_count) + location.reset_in_count.to_f
      else
        location.current_total_in_count = (in_parking_count - out_parking_count) + location.reset_in_count.to_f
      end
    end
  end

  def self.location_settings_list(user_id)
    location_settings_data = Location.select('
      locations.id as id,
      NULL as facilitiy_event_number,
      name,
      address,
      NULL as opening_hours,
      NULL as phone_number,
      NULL as holiday,
      NULL as available_payment,
      NULL as offical_url,
      image,
      capacity,
      camera_flag,
      crowd_level_display,
      display_flag,
      NULL as outline,
      related_facilities_events,
      NULL as facility_event_type,
      display_order,
      user_authorities.authority as authority,
      2 as kbn
    ').joins('
      LEFT OUTER JOIN user_authorities
      ON user_authorities.location_id = locations.id
      AND user_authorities.user_id =' + user_id)
  end

  def self.update_location(id, params)
    location = Location.find(id)
    location.update!(
      name: params[:name],
      address: params[:address],
      capacity: params[:capacity],
      related_facilities_events: params[:related_facilities_events]
    )
  end

  def self.update_location_setting(id, data)
    if data.present?
      location_setting_data = Location.find(id)
      location_setting_list = {}
      location_setting_list[:name] = data[:name]
      location_setting_list[:address] = data[:address]
      location_setting_list[:image] = data[:image]
      location_setting_list[:capacity] = data[:capacity]
      location_setting_list[:crowd_level_display] = data[:crowd_level_display]
      location_setting_list[:display_flag] = data[:display_flag]
      location_setting_list[:display_order] = data[:display_order]
      location_setting_data.update!(location_setting_list)
    end
  end

  def present_address
    address.present?
  end

  def present_related_facilities_events
    related_facilities_events.present?
  end
end
