class Client < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :locations, dependent: :destroy
  has_many :parking_summaries, dependent: :destroy
end
