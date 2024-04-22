require 'rails_helper'

RSpec.describe ParkingSummarizeJob, type: :job do
  include ActiveJob::TestHelper

  before :all do
    @client = FactoryBot.create(:client)
    @location = FactoryBot.create(:location)
    @c_model = FactoryBot.create(:parking_summary, client: @client, location: @location)
  end

  subject(:job) { described_class.perform_later(@c_model.id) }
  it 'queues the job' do
    expect { job }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
  end

  it 'matches with enqueued job' do
    expect { described_class.perform_later }.to have_enqueued_job(described_class)
  end

  it 'is in default queue' do
    expect(described_class.new.queue_name).to eq('default')
  end

  it 'perform' do
    perform_enqueued_jobs { job }
  end

  it 'parking_summary is zero' do
    ParkingSummary.find(@c_model.id).delete
    @camera = FactoryBot.create(:camera)
    FactoryBot.create(:parking, camera_id: @camera.id)
    perform_enqueued_jobs { job }
  end
end
