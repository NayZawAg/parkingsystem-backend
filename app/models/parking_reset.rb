class ParkingReset < ApplicationRecord
  belongs_to :location

  validates :total_in_count, presence: { message: CONSTANTS::ERR_REQUIRED }
  validates :reset_in_count, presence: { message: CONSTANTS::ERR_REQUIRED }
end
