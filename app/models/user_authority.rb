class UserAuthority < ApplicationRecord
  has_many :locations, dependent: :destroy
  has_many :facilities_events, dependent: :destroy
end
