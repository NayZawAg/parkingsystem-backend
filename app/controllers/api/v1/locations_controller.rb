module Api
  module V1
    # Locations controller
    class LocationsController < ApplicationController
      before_action :authenticate

      def index
        @locations = Location.where(camera_flag: 1)
      end

      def show
        @location_detail = Location.find(params[:id])
        render json: @location_detail, status: :ok
      rescue ActiveRecord::RecordNotFound => e
        render_not_found_error(e)
      rescue StandardError => e
        render_internal_server_error(e)
      end

      def update_location_information
        update_location = Location.update_location(params[:id], update_params)
        render json: update_location, status: :ok
      rescue ActiveRecord::RecordNotFound => e
        render_not_found_error(e)
      rescue StandardError => e
        render_internal_server_error(e)
      end

      def update_params
        params.permit(
          :name,
          :address,
          :capacity,
          :related_facilities_events
        )
      end
    end
  end
end
