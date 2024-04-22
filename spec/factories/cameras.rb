FactoryBot.define do
  factory :camera do
    location
    name { '入口' }
    in_flg { true }
    out_flg { false }
    dbx_folder_name { 'ZSSPEL66V5DWYX93111A' }
    dbx_acquired_at { '2022-01-01 01:01:01' }
  end
end
