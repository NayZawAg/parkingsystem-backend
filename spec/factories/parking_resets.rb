FactoryBot.define do
  factory :parking_reset do
    location
    total_in_count { 1 }
    reset_in_count { 1 }
  end
end
