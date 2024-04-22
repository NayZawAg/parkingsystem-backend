FactoryBot.define do
  factory :parking do
    camera
    in_out_flg { false }
    parking_time { '2021-12-27 18:05:46' }
    car_area { '横浜' }
    car_number { 'あ1111 11-11' }
  end
end
