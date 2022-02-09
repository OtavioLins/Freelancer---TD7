# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectApplicationMailer, type: :mailer do
  context 'New application' do
    it 'should warn project owner' do
      project_application = create(:project_application)

      mail = ProjectApplicationMailer.with(project_application: project_application).notify_new_application

      expect(mail.to).to eq [project_application.project.user.email]
      expect(mail.from).to eq ['nao-responda@freelancer.com.br']
      expect(mail.subject).to eq 'Nova aplicação para seu projeto'
      expect(mail.body).to include "Seu projeto #{project_application.project.title} teve uma nova aplicação por #{project_application.professional.profile.social_name}."
    end
  end
end
