# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectApplicationMailer, type: :mailer do
  context 'New application' do
    it 'should warn project owner' do
      user = User.create!(email: 'otavio@freelancer.com.br', password: '123456')
      project = Project.create!(title: 'Sistema de aluguel de imóveis',
                                description: 'Projeto que visa criar uma aplicação...',
                                skills: 'Conhecimento em Rails, Web Design e segurança',
                                date_limit: 20.days.from_now, work_regimen: :remote,
                                hour_value: 300, user: user, status: :open)

      professional = Professional.create!(email: 'otavio@professional.com.br', password: 'ahudufgvya')
      occupation_area = OccupationArea.create!(name: 'Dev')
      profile = Profile.create!(birth_date: 18.years.ago, full_name: 'Otávio Lins',
                                social_name: 'Otávio Augusto', prior_experience: 'Nenhuma',
                                educational_background: 'Matemático', occupation_area: occupation_area,
                                description: 'Profissional em mud...', professional: professional)

      project_application = ProjectApplication.create!(motivation: 'Trabalhei em ...', expected_conclusion: '1 mês',
                                                       weekly_hours: 10, expected_payment: 100, project: project, professional: professional,
                                                       situation: :analysis)

      mail = ProjectApplicationMailer.with(project_application: project_application).notify_new_application

      expect(mail.to).to eq ['otavio@freelancer.com.br']
      expect(mail.from).to eq ['nao-responda@freelancer.com.br']
      expect(mail.subject).to eq 'Nova aplicação para seu projeto'
      expect(mail.body).to include 'Seu projeto Sistema de aluguel de imóveis teve uma nova aplicação por Otávio Augusto.'
    end
  end
end
