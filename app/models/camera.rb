class Camera < ApplicationRecord
  belongs_to :location
  has_many :parking_videos, dependent: :destroy
  has_many :parkings, dependent: :destroy

  scope :with_locations, lambda {
    joins(:location)
  }
end
