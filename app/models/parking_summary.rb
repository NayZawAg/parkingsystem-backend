# ParkingSummary model
class ParkingSummary < ApplicationRecord
  belongs_to :client
  belongs_to :location

  scope :search_by_location, ->(location_id) { where('location_id = ?', location_id) }
  scope :search_with_day_types, ->(day_types) { where('day_type IN (?)', day_types) }
  scope :within_location_time_range, -> {
    joins("INNER JOIN locations ON locations.id = parking_summaries.location_id")
      .where("locations.opening_time <= parking_summaries.time AND locations.closing_time >= parking_summaries.time")
  }

  def self.congestion_rates(params, location)
    day_types = [0]
    day_types = [1, 2] if params[:day_type] == 'holiday'
    ParkingSummary.search_by_location(location.id)
                  .search_with_day_types(day_types)
                  .group('date').count
  end

  def self.calculate_congestion_rates(total_capacity, location, params)
    day_types = [0]
    day_types = [1, 2] if params[:day_type] == 'holiday'
    ParkingSummary.select("CONVERT(VARCHAR(5), time, 108) AS parking_time,
                           CONVERT(float, ((SUM(in_total) * 100.00) / #{total_capacity})) AS congestion_rate")
                  .joins("INNER JOIN locations ON locations.id = parking_summaries.location_id")
                  .search_by_location(location.id)
                  .search_with_day_types(day_types)
                  .within_location_time_range
                  .group('time')
                  .order('time')
  end
end
