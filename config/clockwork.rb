# clockwork (gem) の実行用ファイル

require 'clockwork'
require 'active_support/time' # Allow numeric durations (eg: 1.minutes)
require './config/boot'
require './config/environment'

# 5の倍数分時点で開始するために待機
sleep 1 while Time.zone.now.min % 5 != 0

module Clockwork
  handler do |job|
    job&.perform_now
  end

  every(1.day, ParkingSummarizeJob, at: '23:00')
end
