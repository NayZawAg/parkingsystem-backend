module Api
  module V1
    class SettingsController < ApplicationController
      before_action :authenticate

      def index
        user_id = @current_user.id.to_s

        facility_data = FacilitiesEvent.facility_settings_list(user_id)
        location_data = Location.location_settings_list(user_id)

        @settings = (facility_data + location_data).sort_by(&:display_order)
      end

      def update_display_setting
        if params[:setting_data].present?
          params[:setting_data].each do |data|
            @setting_update = if data[:kbn] == 1
                                FacilitiesEvent.update_facility_setting(data[:id], setting_update_params(data))
                              else
                                Location.update_location_setting(data[:id], setting_update_params(data))
                              end
          end
          render json: @setting_update, status: :ok
        end
      rescue ActiveRecord::RecordInvalid => e
        render_unprocessable_entity(e)
      rescue ActiveRecord::RecordNotFound => e
        Rails.logger.debug(e)
        render_not_found(CONSTANTS::ERR_NOT_FOUND)
      rescue StandardError => e
        render_internal_server_error(e)
      end

      def setting_update_params(data)
        data.permit(
          :id,
          :name,
          :address,
          :opening_hours,
          :phone_number,
          :available_payment,
          :offical_url,
          :image,
          :capacity,
          :crowd_level_display,
          :display_flag,
          :outline,
          :facility_event_type,
          :display_order,
          :authority,
          :kbn
        )
      end
    end
  end
end
