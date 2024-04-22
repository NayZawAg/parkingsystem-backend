module Api
  module V1
    # Facilities_events controller
    class FacilitiesEventsController < ApplicationController
      def index
        @facilities_events = FacilitiesEvent.all
      end

      def show
        @facilities_events_detail = FacilitiesEvent.find(params[:id])
        render json: @facilities_events_detail, status: :ok
      rescue ActiveRecord::RecordNotFound => e
        render_not_found_error(e)
      rescue StandardError => e
        render_internal_server_error(e)
      end

      def update_facility_information
        update_facilities_event = FacilitiesEvent.update_facility(params[:id], update_params)
        render json: update_facilities_event, status: :ok
      rescue ActiveRecord::RecordNotFound => e
        render_not_found_error(e)
      rescue StandardError => e
        render_internal_server_error(e)
      end

      def update_params
        params.permit(
          :name,
          :address,
          :opening_hours,
          :holiday,
          :available_payment,
          :offical_url,
          :outline
        )
      end
    end
  end
end
