FactoryBot.define do
  factory :parking_summary do
    client
    location
    date { '2022-01-18' }
    time { '11:00:00' }
    day_type { 0 }
    in_total { 2 }
    out_total { 0 }
  end
end
