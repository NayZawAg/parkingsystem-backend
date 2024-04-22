FactoryBot.define do
  factory :user do
    client
    username { '田中太郎' }
    password { '12345678' }
    active { false }
  end
end
