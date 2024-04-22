class User < ApplicationRecord
  belongs_to :client
  has_secure_password
  validates :username, presence: { message: CONSTANTS::ERR_REQUIRED }, uniqueness: { message: CONSTANTS::ERR_ALREADY_TAKEN }
end
