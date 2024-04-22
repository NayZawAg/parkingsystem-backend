module UtilsHelper
  class ValidationError
    def initialize(response_body)
      @count = 0
      @parsed_response = JSON.parse(response_body).deep_symbolize_keys
    end

    def body
      @parsed_response
    end

    def error_type(_error_item_name)
      err_arr = @parsed_response[:errors]
      @count += 1
      err_arr[@count - 1]
    end
  end
end
