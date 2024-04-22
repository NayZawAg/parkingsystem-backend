# ParkingSummarizeJob
class ParkingSummarizeJob < ApplicationJob
  queue_as :default

  def perform(start_date = nil, end_date = nil)
    Rails.logger.info('##### Begin summarize #####')

    now = Time.zone.now
    if start_date.present? && end_date.present?
      Rails.logger.info("Summarize by specific date range: #{start_date} - #{end_date}")
      start_date = "#{start_date} 00:00:00"
      end_date = "#{end_date} 23:59:59"
    else
      Rails.logger.info("Summarize by scheduler: #{now.strftime('%Y-%m-%d')}")
      # summarize_date_range
      date_range = summarize_date_range(now)
      start_date = date_range[:start_date]
      end_date = date_range[:end_date]
    end
    puts "Start Date : #{start_date}"
    puts "End Date : #{end_date}"
    holiday_list = holidays(start_date, end_date)
    holidays_join = "''"
    holidays_join = '%s' % holiday_list.map { |cc| "'#{cc}'" }.join(',') unless holiday_list.length.zero?
    # Select from parkings
    parking_select = Parking.select("
    l.client_id AS client_id,
    l.id AS location_id,
    CONVERT(DATE, parkings.parking_time) AS date,
    FORMAT(CAST(parkings.parking_time AS datetime2), N'HH:00') AS time,
    CASE
    WHEN CONVERT(DATE, parkings.parking_time) IN (#{holidays_join}) THEN 2
    WHEN (DATEPART(DW, CONVERT(DATE, parkings.parking_time)) = 1 OR
    DATEPART(DW, CONVERT(DATE, parkings.parking_time)) = 7) THEN 1
    ELSE 0
    END AS day_type,
    COUNT(CASE WHEN parkings.in_out_flg = 0 THEN parkings.id END) AS in_total,
    COUNT(CASE WHEN parkings.in_out_flg = 1 THEN parkings.id END) AS out_total")
                            .joins("
    INNER JOIN cameras AS c ON c.id = parkings.camera_id
    INNER JOIN locations AS l ON l.id = c.location_id")
                            .where("
    (FORMAT(CAST(parkings.parking_time AS datetime2), N'HH:mm') >= l.start_time AND
    FORMAT(CAST(parkings.parking_time AS datetime2), N'HH:mm') <= l.end_time) AND
    (parkings.parking_time >= ? AND parkings.parking_time <= ?)", start_date, end_date)
                            .group("
    l.client_id, l.id,
    CONVERT(DATE, parkings.parking_time),
    FORMAT(CAST(parkings.parking_time AS datetime2), N'HH:00')")
                            .order('date, time')
    puts "Selected Parkings : #{parking_select.length}"
    # Insert into parking summary
    parking_select.each do |parking|
      parking_summary = ParkingSummary.find_or_initialize_by(
        client_id: parking.client_id,
        location_id: parking.location_id,
        date: parking.date.strftime('%Y-%m-%d'),
        time: parking.time,
        day_type: parking.day_type,
      )
      parking_summary.in_total = parking.in_total
      parking_summary.out_total = parking.out_total
      parking_summary.save!
    end
    Rails.logger.info('##### End summarize #####')
  rescue StandardError => e
    Rails.logger.error(e.message)
  end

  private

  def summarize_date_range(now)
    start_date = nil
    end_date = nil
    if ParkingSummary.exists?
      yesterday = now - 1.days
      start_date = yesterday.beginning_of_day
      end_date = yesterday.end_of_day
    else
      start_date = Parking.minimum(:parking_time)
      end_date = Parking.maximum(:parking_time)
    end
    {
      start_date: start_date.strftime('%Y-%m-%d 00:00:00'),
      end_date: end_date.strftime('%Y-%m-%d 23:59:59')
    }
  end

  def holidays(start_date, end_date)
    holiday_list = []
    # Get japanese holidays in start date and end date.
    holidays = HolidayJp.between(start_date, end_date)
    holidays.each do |holiday|
      holiday_list.push(holiday.date.strftime('%Y-%m-%d'))
    end
    holiday_list
  end
end
