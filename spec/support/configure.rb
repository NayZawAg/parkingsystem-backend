RSpec.configure do |config|
  config.before(:suite) do
    # Database clean
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)

    # Seed data
    Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].sort.each do |seed|
      load seed
    end
  end
end
