# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe MailDeliveryJob, type: :job do
  it 'should enqueue a Email job' do
    project_application = create(:project_application)

    assert_equal 0, Sidekiq::Queues['default'].size
    MailDeliveryJob.perform_later(project_application.id)
    assert_equal 1, Sidekiq::Queues['default'].size
  end
end
