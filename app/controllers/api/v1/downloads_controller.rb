module Api
  module V1
    # Downloads controller
    class DownloadsController < ApplicationController
      include TokenAuthenticator
      before_action :set_secret_token
      before_action :validate_params_blank
      before_action :validate_params_format

      def request_token
        request.headers['access-token']
      end

      def parkings
        if @signature == request_token
          @download_parking = Parking.search_parking_data(params)

          @in_out_count = Parking.search_in_out_count(params)
          type = CONSTANTS::COD_DOWNLOAD_PARKING_ITEM_DATA
          l_param = {
            search_query: {
              item_name: CONSTANTS::PARKING_ITEM_NAME,
              from_year_month: params[:from_year_month],
              to_year_month: params[:to_year_month]
            },
            search_result: {
              out_count: @in_out_count.fetch(:out_count),
              in_count: @in_out_count.fetch(:in_count),
              total_count: @in_out_count.fetch(:out_count) + @in_out_count.fetch(:in_count)
            }
          }.to_json
          Log.create(type: type, content: l_param)
          render json: @download_parking.as_json(except: [:camera_id]), status: :ok
        end
      rescue StandardError => e
        Rails.logger.error(e)
        render_internal_server_error(e)
      end

      def chatbots
        if @signature == request_token
          @download_chatbot = ChatbotData.search_chatbot_data(params)
          type = CONSTANTS::COD_DOWNLOAD_CHATBOT_ITEM_DATA
          l_param = {
            search_query: {
              item_name: CONSTANTS::CHATBOT_ITEM_NAME,
              from_year_month: params[:from_year_month],
              to_year_month: params[:to_year_month]
            },
            search_result: {
              total_count: @download_chatbot.count
            }
          }.to_json
          Log.create(type: type, content: l_param)
          render json: @download_chatbot, status: :ok
        end
      rescue ActiveRecord::RecordInvalid => e
        render_unprocessable_entity(e)
      rescue ActiveRecord::RecordNotFound => e
        Rails.logger.debug(e)
        render_not_found(CONSTANTS::ERR_NOT_FOUND)
      rescue StandardError => e
        Rails.logger.error(e)
        render_internal_server_error(e)
      end

      private

      def set_secret_token
        url = url_for(from_year_month: params[:from_year_month], to_year_month: params[:to_year_month])
        data = url.split('?')
        token = ENV['SECRET_TOKEN']
        @signature = token_authenticate(data[1], token)
        return render_unauthorized(CONSTANTS::ERR_UNAUTHORIZED) unless @signature == request_token
      end

      def validate_params_blank
        return render_bad_request unless params[:from_year_month].present? && params[:to_year_month].present?
      end

      def validate_params_format
        validate_from_year_month = params[:from_year_month].match?(/\A\d{4}-\d{2}\z/)
        validate_to_year_month = params[:to_year_month].match?(/\A\d{4}-\d{2}\z/)
        return render_bad_request unless validate_from_year_month && validate_to_year_month
      end
    end
  end
end
