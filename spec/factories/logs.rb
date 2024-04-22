FactoryBot.define do
  factory :log do
    user
    type { 'search_parking_data' }
    content { '{"search_query":{"location_name":"広島三次ワイナリー","from_date":"2023-02-28","to_date":"2023-02-28"},"search_result":{"out_count":36,"in_count":36,"total_count":72}}' }
  end
end
