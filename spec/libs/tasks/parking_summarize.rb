require 'rails_helper'
require 'rake'

RSpec.describe 'ParkingSummarize' do
  before(:all) do
    @rake = Rake::Application.new
    Rake.application = @rake
    Rake.application.rake_require('parking_summarize', ["#{Rails.root}/lib/tasks"])
    Rake::Task.define_task(:environment)
  end

  before(:each) do
    @rake[task].reenable
  end

  # Task summarize
  describe 'task: summarize' do
    let(:task) { 'parking_summarize:summarize' }

    it 'parking_summary count zero' do
      @camera = FactoryBot.create(:camera)
      FactoryBot.create(:parking, camera_id: @camera.id)
      @rake[task].invoke
    end

    it 'parking_summary count does not zero' do
      @rake[task].invoke
    end
  end
end
