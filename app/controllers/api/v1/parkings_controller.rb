module Api
  module V1
    # Parking controller
    class ParkingsController < ApplicationController
      include PaginationUtil

      before_action :authenticate, except: [:create, :locations, :congestion_rates]
      before_action :apikey_authenticate, only: [:create]
      before_action :set_camera, only: [:create]
      before_action :set_location, only: [:congestion_rates]
      before_action :set_user, only: [:situations]

      def locations
        locations = Location.search_with_cameras_locations

        render json: locations.as_json(except: [:camera_ids, :reset_in_count, :created_at]), status: :ok
      rescue StandardError => e
        Rails.logger.error(e)
        render_internal_server_error(e)
      end

      def congestion_rates
        return render_bad_request unless params[:day_type] == 'business' || params[:day_type] == 'holiday'

        begin
          date_group_summary = ParkingSummary.congestion_rates(params, @location)

          total_capacity = date_group_summary.length * @location.capacity_calculation
          return render json: [] if total_capacity.zero?

          congestion_rates = ParkingSummary.calculate_congestion_rates(total_capacity, @location, params)

          render json: congestion_rates.as_json(except: [:id]), status: :ok
        rescue ActiveRecord::RecordNotFound => e
          Rails.logger.debug(e)
          render_not_found(CONSTANTS::ERR_NOT_FOUND)
        rescue StandardError
          Rails.logger.error(e)
          render_internal_server_error(e)
        end
      end

      def resets
        locations = Location.search_with_cameras_resets

        render json: locations.as_json(except: [
          :camera_ids,
          :start_time,
          :end_time,
          :reset_datetime,
          :total_in_count,
          :reset_in_count,
          :created_at
        ]), status: :ok
      rescue StandardError => e
        Rails.logger.error(e)
        render_internal_server_error(e)
      end

      def create_reset
        Location.find(reset_params[:location_id])
        reset_created_updated_by = reset_params.merge(created_by:current_user.id, updated_by:current_user.id)
        reset_parking = ParkingReset.create!(reset_created_updated_by)
        render json: reset_parking.as_json(only: [:location_id, :total_in_count, :reset_in_count]), status: :created
      rescue ActiveRecord::RecordInvalid => e
        render_unprocessable_entity(e)
      rescue ActiveRecord::RecordNotFound => e
        Rails.logger.debug(e)
        render_not_found(CONSTANTS::ERR_NOT_FOUND)
      rescue StandardError => e
        render_internal_server_error(e)
      end

      def create
        res = Parking.entry(parking_params)
        render res
      rescue ActiveRecord::RecordInvalid => e
        render_unprocessable_entity(e)
      rescue ActiveRecord::RecordNotFound => e
        Rails.logger.debug(e)
        render_not_found(CONSTANTS::ERR_NOT_FOUND)
      rescue StandardError => e
        render_internal_server_error(e)
      end

      def situations
        return render_bad_request unless params[:from_date].present? && params[:to_date].present?

        @in_out_count = Parking.in_out_count(params)
        @paginated_parkings = Parking.search(params)
        @meta = nil
        @meta = pagination_dict(@paginated_parkings) if params[:page].present? && params[:per_page].present?
        l_param = {
          search_query: {
            location_name: params[:location_name],
            from_date: params[:from_date],
            to_date: params[:to_date]
          },
          search_result: {
            out_count: @in_out_count.fetch(:out_count),
            in_count: @in_out_count.fetch(:in_count),
            total_count: @in_out_count.fetch(:out_count) + @in_out_count.fetch(:in_count)
          }
        }.to_json
        type = if params[:page].present? && params[:per_page].present?
                 CONSTANTS::COD_SEARCH_PARKING_DATA
               else
                 CONSTANTS::COD_DOWNLOAD_PARKING_DATA
               end
        Log.create(user_id: @user.id, type: type, content: l_param)
      rescue StandardError => e
        render_internal_server_error(e)
      end

      private

      def reset_params
        params.permit(:location_id, :total_in_count, :reset_in_count)
      end

      def parking_params
        params.permit(:apikey, :camera_id, result: [:in_out, :parking_time, :car_area, :car_number])
      end

      def apikey_authenticate
        ENV['API_KEY'] == parking_params[:apikey] || render_unauthorized(CONSTANTS::ERR_UNAUTHORIZED)
      end

      def set_camera
        @camera = Camera.find(parking_params[:camera_id])
      rescue ActiveRecord::RecordNotFound => e
        Rails.logger.debug(e)
        render_not_found(CONSTANTS::ERR_NOT_FOUND)
      rescue StandardError => e
        Rails.logger.error(e)
        render_internal_server_error(e)
      end

      def set_location
        @location = Location.find(params[:id])
      rescue ActiveRecord::RecordNotFound => e
        Rails.logger.debug(e)
        render_not_found(CONSTANTS::ERR_NOT_FOUND)
      rescue StandardError => e
        Rails.logger.error(e)
        render_internal_server_error(e)
      end

      def set_user
        @user = User.find_by(id: current_user.id)
      rescue ActiveRecord::RecordNotFound => e
        Rails.logger.debug(e)
        render_not_found(CONSTANTS::ERR_NOT_FOUND)
      rescue StandardError => e
        Rails.logger.error(e)
        render_internal_server_error(e)
      end

      def situations_params
        params.permit(:from_date, :to_date, :location_name, :page, :per_page)
      end
    end
  end
end
