# frozen_string_literal: true

class MailDeliveryJob < ApplicationJob
  queue_as :default

  def perform(project_application_id)
    project_application = ProjectApplication.find(project_application_id)
    project_application.notify_new_application.deliver
  end
end
