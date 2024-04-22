FactoryBot.define do
  factory :location do
    client
    name { '広島三次ワイナリー' }
    address { '広島県三次市東酒屋町10445-3' }
    lat { 34.7778000 }
    lng { 132.8666100 }
    image { 'HiroshimaMiyoshiWinery.jpg' }
    capacity { 1 }
    start_time { '00:00:00' }
    end_time { '23:59:59' }
  end
end
