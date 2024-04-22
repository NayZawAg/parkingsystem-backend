require 'yaml'
require 'active_support/testing/time_helpers'

ENV['SEED_DEVELOPMENT'] = 'yes'

# Support
class Support
  extend ActiveSupport::Testing::TimeHelpers

  def self.benchmark(title, &block)
    print "\e[32m# #{title}: \e[0m"
    result = Benchmark.realtime(&block)
    puts "\e[32m#{result.round(3).to_s.ljust(5, '0')}s\e[0m"
  end

  def self.yaml_each(directory_name)
    path = Rails.root.join('db', 'seeds', 'yaml', directory_name, '*.yml')
    Dir.glob(path).sort.each do |file|
      yaml = YAML.load_file(file).deep_symbolize_keys
      yield(yaml, File.basename(file))
    end
  end
end

# Random util
module RandomUtil
  def percent_true(random = Random::DEFAULT)
    apply = self >= random.rand(0..100)
    yield if apply && block_given?
    apply
  end

  alias percent_apply percent_true
end

Integer.prepend(RandomUtil)
