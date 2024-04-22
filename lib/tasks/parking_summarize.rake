namespace :parking_summarize do
  desc 'summarize'
  task :summarize do
    logger = Rails.logger
    begin
      logger.info('##### Begin summarize #####')

      parking_summary_count = ParkingSummary.count
      holiday_list = []
      start_date = ''
      end_date = ''
      if parking_summary_count.zero?
        # Earliest parkings
        earliest_parking = Parking.select(:parking_time).order('parking_time ASC').first
        start_date = earliest_parking.parking_time
        # Lastest parkings
        latest_parking = Parking.select(:parking_time).order('parking_time DESC').first
        end_date = latest_parking.parking_time
      else
        # yesterday
        yesterday = Date.today - 1.day
        start_date = yesterday.strftime('%Y-%m-%d 00:00:00')
        end_date = yesterday.strftime('%Y-%m-%d 23:59:59')
      end
      puts "Start Date : #{start_date}"
      puts "End Date : #{end_date}"
      # Get japanese holidays in start date and end date.
      holidays = HolidayJp.between(start_date, end_date)
      holidays.each do |holiday|
        holiday_list.push(holiday.date.strftime('%Y-%m-%d'))
      end
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
        parking_summary = ParkingSummary.select('*').where(client_id: parking.client_id, location_id: parking.location_id, date: parking.date, time: parking.time).first
        if parking_summary.nil?
          parking_params = {  'client_id' => parking.client_id,
                              'location_id' => parking.location_id,
                              'date' => parking.date.strftime('%Y-%m-%d'),
                              'time' => parking.time,
                              'day_type' => parking.day_type,
                              'in_total' => parking.in_total,
                              'out_total' => parking.out_total }
          parking_summary = ParkingSummary.new(parking_params)
          parking_summary.save!
        else
          in_total = parking_summary.in_total + parking.in_total
          out_total = parking_summary.out_total + parking.out_total
          ParkingSummary.where(client_id: parking.client_id, location_id: parking.location_id, date: parking.date, time: parking.time)
                        .update(in_total: in_total, out_total: out_total)
        end
      end
      logger.info('##### End summarize #####')
    rescue StandardError => e
      Rails.logger.error(e.message)
    end
  end
end
