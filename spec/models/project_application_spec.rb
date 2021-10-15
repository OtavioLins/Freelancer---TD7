require 'rails_helper'

describe ProjectApplication do
    context 'Validation:' do
        it 'Creation - Presence' do
            @project_application = ProjectApplication.new
            @project_application.valid?

            expect(@project_application.errors.full_messages_for(:motivation)).to include(
            'Porque se acha capaz de pegar esse projeto? é obrigatório(a)')
            expect(@project_application.errors.full_messages_for(:weekly_hours)).to include(
            'Horas semanais que pretende trabalhar no projeto é obrigatório(a)')
            expect(@project_application.errors.full_messages_for(:expected_conclusion)).to include(
            'Expectativa de conclusão é obrigatório(a)')
            expect(@project_application.errors.full_messages_for(:expected_payment)).to include(
            'Valor que espera receber por hora é obrigatório(a)')
        end
        it 'Creation - expected_payment and weekly_hours must be numbers' do
            @user = User.create!(email: 'otavio@user.com', password: '123131')
            @project = Project.create!(title: 'Sistema de aluguel de imóveis',
                description: 'Projeto que visa criar uma aplicação para oferecer imóveis alugáveis em todo o estado de São Paulo',
                skills: 'Conhecimento em Rails, Web Design e segurança',
                date_limit: 20.days.from_now, work_regimen: :remote,
                hour_value: 300, user: @user, status: :open)
            @professional = Professional.create!(email: 'otavio@professional.com.br', password: 'ahudufgvya')
            @occupation_area = OccupationArea.create!(name: 'Dev')
            @profile = Profile.create!(birth_date: 18.years.ago, full_name: 'Otávio Lins', 
                social_name: 'Otávio Augusto', prior_experience: 'Trabalhei como desenvolvedor em rails numa startup X',
                educational_background: 'Matemático', occupation_area: @occupation_area,
                description: 'Profissional em mud...', professional: @professional)
            @project_application = ProjectApplication.new(motivation: 'Trabalhei em ...', expected_conclusion: '1 mês',
                weekly_hours: -10, expected_payment: 'sjfhdBIAGML', project: @project, professional: @professional,
                situation: :analysis)
            @project_application.valid?

            expect(@project_application.errors.full_messages_for(:weekly_hours)).to include(
            'Horas semanais que pretende trabalhar no projeto deve ser um número positivo')
            expect(@project_application.errors.full_messages_for(:expected_payment)).to include(
            'Valor que espera receber por hora deve ser um número positivo')
        end

        it 'Creation - expected_payment cannot excede a certain value' do
            @user = User.create!(email: 'otavio@user.com', password: '123131')
            @project = Project.create!(title: 'Sistema de aluguel de imóveis',
                description: 'Projeto que visa criar uma aplicação para oferecer imóveis alugáveis em todo o estado de São Paulo',
                skills: 'Conhecimento em Rails, Web Design e segurança',
                date_limit: 20.days.from_now, work_regimen: :remote,
                hour_value: 300, user: @user, status: :open)
            @professional = Professional.create!(email: 'otavio@professional.com.br', password: 'ahudufgvya')
            @occupation_area = OccupationArea.create!(name: 'Dev')
            @profile = Profile.create!(birth_date: 18.years.ago, full_name: 'Otávio Lins', 
                social_name: 'Otávio Augusto', prior_experience: 'Trabalhei como desenvolvedor em rails numa startup X',
                educational_background: 'Matemático', occupation_area: @occupation_area,
                description: 'Profissional em mud...', professional: @professional)
            @project_application = ProjectApplication.new(motivation: 'Trabalhei em ...', expected_conclusion: '1 mês',
                weekly_hours: 10, expected_payment: 550, project: @project, professional: @professional,
                situation: :analysis)
                
            @project_application.valid?

            expect(@project_application.errors.full_messages_for(:expected_payment)).to include(
            'Valor que espera receber por hora não pode ser maior que o valor máximo por hora estipulado')
        end
    end
end