# Log model
class Log < ApplicationRecord
  # belongs_to :user
  self.inheritance_column = :_type_disabled
end
