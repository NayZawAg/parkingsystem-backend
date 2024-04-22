class FacilitiesEvent < ApplicationRecord
  belongs_to :user_authorities, optional: true
  validates :address, length: { maximum: 255 }, if: :present_address
  validates :opening_hours, length: { maximum: 255 }, if: :present_opening_hours
  validates :holiday, length: { maximum: 255 }, if: :present_holiday
  validates :available_payment, length: { maximum: 255 }, if: :present_available_payment
  validates :outline, length: { maximum: 255 }, if: :present_outline
  validates :offical_url, format: /\A#{URI::DEFAULT_PARSER.make_regexp(%w[http https])}\z/, if: :present_offical_url

  def self.facility_settings_list(user_id)
    facility_settings_data = FacilitiesEvent.select('
      facilities_events.id as id,
      facilitiy_event_number,
      name,
      address,
      opening_hours,
      phone_number,
      holiday,
      available_payment,
      offical_url,
      image,
      NULL as capacity,
      NULL as camera_flag,
      NULL as crowd_level_display,
      display_flag,
      outline,
      NULL as related_facilities_events,
      facility_event_type,
      display_order,
      user_authorities.authority as authority,
      1 as kbn
    ').joins('
      LEFT OUTER JOIN user_authorities
      ON user_authorities.facilities_event_id = facilities_events.id
      AND user_authorities.user_id = ' + user_id)
  end

  def self.update_facility(id, params)
    facilities_event = FacilitiesEvent.find(id)
    facilities_event.update!(
      name: params[:name],
      address: params[:address],
      opening_hours: params[:opening_hours],
      holiday: params[:holiday],
      available_payment: params[:available_payment],
      offical_url: params[:offical_url],
      outline: params[:outline]
    )
  end

  def self.update_facility_setting(id, data)
    if data.present?
      facilities_setting_data = FacilitiesEvent.find(id)
      facilities_setting_list = {}
      facilities_setting_list[:name] = data[:name]
      facilities_setting_list[:address] = data[:address]
      facilities_setting_list[:opening_hours] = data[:opening_hours]
      facilities_setting_list[:phone_number] = data[:phone_number]
      facilities_setting_list[:available_payment] = data[:available_payment]
      facilities_setting_list[:offical_url] = data[:offical_url]
      facilities_setting_list[:image] = data[:image]
      facilities_setting_list[:display_flag] = data[:display_flag]
      facilities_setting_list[:outline] = data[:outline]
      facilities_setting_list[:facility_event_type] = data[:facility_event_type]
      facilities_setting_list[:display_order] = data[:display_order]
      facilities_setting_data.update!(facilities_setting_list)
    end
  end

  def present_address
    address.present?
  end

  def present_opening_hours
    opening_hours.present?
  end

  def present_holiday
    holiday.present?
  end

  def present_available_payment
    available_payment.present?
  end

  def present_outline
    outline.present?
  end

  def present_offical_url
    offical_url.present?
  end
end
