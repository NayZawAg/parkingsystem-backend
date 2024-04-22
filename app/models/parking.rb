require 'date'
# Parking model
class Parking < ApplicationRecord
  belongs_to :camera

  scope :search_by_date, ->(from_date, to_date) { where('CONVERT(date, parking_time) BETWEEN ? AND ?', from_date, to_date) }
  scope :search_with_in_out_flg, ->(in_out_flg) { where('in_out_flg = ?', in_out_flg) }
  scope :search_with_location_name, ->(location_name) { where('locations.name = ?', location_name) }
  scope :search_by_parking_date, ->(from_year_month, to_year_month) { where("FORMAT(CAST(parking_time AS datetime), N'yyyy-MM') BETWEEN ? AND ?", from_year_month, to_year_month) }

  def self.entry(parkings_params)
    parkings_params[:result].each do |parking|
      next if parking[:in_out].blank? || parking[:parking_time].blank?

      p_params = {
        "camera_id": parkings_params[:camera_id],
        "in_out_flg": parking[:in_out],
        "parking_time": parking[:parking_time],
        "car_area": parking[:car_area],
        "car_number": parking[:car_number]
      }
      Parking.create!(p_params)
    end
    { json: {}, status: :created }
  end

  def self.in_out_count(params)
    out_count = Parking.select('COUNT(in_out_flg) AS out_count')
                       .joins(:camera)
                       .merge(Camera.with_locations)
                       .search_by_date(params[:from_date], params[:to_date])
                       .search_with_in_out_flg(true)
    in_count = Parking.select('COUNT(in_out_flg) AS in_count')
                      .joins(:camera)
                      .merge(Camera.with_locations)
                      .search_by_date(params[:from_date], params[:to_date])
                      .search_with_in_out_flg(false)
    if params[:location_name].present?
      out_count = Parking.select('COUNT(in_out_flg) AS out_count')
                         .joins(:camera)
                         .merge(Camera.with_locations)
                         .search_by_date(params[:from_date], params[:to_date])
                         .search_with_in_out_flg(true)
                         .search_with_location_name(params[:location_name])
      in_count = Parking.select('COUNT(in_out_flg) AS in_count')
                        .joins(:camera)
                        .merge(Camera.with_locations)
                        .search_by_date(params[:from_date], params[:to_date])
                        .search_with_in_out_flg(false)
                        .search_with_location_name(params[:location_name])
    end
    {
      out_count: out_count[0][:out_count],
      in_count: in_count[0][:in_count]
    }
  end

  def self.search(params)
    parkings = Parking.preload(:camera)
                      .joins(:camera)
                      .merge(Camera.with_locations)
                      .search_by_date(params[:from_date], params[:to_date])
    parkings = parkings.search_with_location_name(params[:location_name]) if params[:location_name].present?
    parkings = parkings.order(parking_time: :asc)
    parkings = parkings.page(params[:page]).per(params[:per_page]) if params[:page].present? && params[:per_page].present?
    parkings
  end

  def self.search_parking_data(params)
    Parking.search_by_parking_date(params[:from_year_month], params[:to_year_month])
  end

  def self.search_in_out_count(params)
    out_count = Parking.select('COUNT(in_out_flg) AS out_count')
                       .joins(:camera)
                       .merge(Camera.with_locations)
                       .search_by_parking_date(params[:from_year_month], params[:to_year_month])
                       .search_with_in_out_flg(true)
    in_count = Parking.select('COUNT(in_out_flg) AS in_count')
                      .joins(:camera)
                      .merge(Camera.with_locations)
                      .search_by_parking_date(params[:from_year_month], params[:to_year_month])
                      .search_with_in_out_flg(false)
    {
      out_count: out_count[0][:out_count],
      in_count: in_count[0][:in_count]
    }
  end
end
