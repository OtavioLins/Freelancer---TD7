require 'rails_helper'

describe 'Projects team' do
    context 'User' do
        it 'view the team for his project' do
            @user = User.create!(email: 'otavio@user.com', password: '123131')
            @project = Project.create!(title: 'Sistema de aluguel de imóveis',
                                       description: 'Projeto que visa criar uma aplicação para oferecer imóveis alugáveis em todo o estado de São Paulo',
                                       skills: 'Conhecimento em Rails, Web Design e segurança',
                                       date_limit: 20.days.from_now, work_regimen: :remote,
                                       hour_value: 300, user: @user, status: :open)
            @professional1 = Professional.create!(email: 'otavio@professional.com.br', password: 'ahudufgvya')
            @professional2 = Professional.create!(email: 'josé@professional.com.br', password: 'asufgyiadf')
            @professional3 = Professional.create!(email: 'alana@professional.com.br', password: 'ahfyhdajkbf')
            @occupation_area = OccupationArea.create!(name: 'Dev')
            @profile1 = Profile.create!(birth_date: 18.years.ago, full_name: 'Otávio Lins', 
                                       social_name: 'Otávio Augusto', prior_experience: 'Trabalhei como desenvolvedor em rails numa startup X',
                                       educational_background: 'Matemático', occupation_area: @occupation_area,
                                       description: 'Profissional em mud...', professional: @professional1)
            @profile2 = Profile.create!(birth_date: 18.years.ago, full_name: 'José Bezerra', 
                                        social_name: 'Flynn Rider', prior_experience: 'Trabalhei como desenvolvedor em rails numa startup X',
                                        educational_background: 'Matemático', occupation_area: @occupation_area,
                                        description: 'Esperto, aprendo rápido...', professional: @professional2)
            @profile3 = Profile.create!(birth_date: 18.years.ago, full_name: 'Alana Xeherazade', 
                                        social_name: 'Alana Xeherazade', prior_experience: 'Trabalhei como desenvolvedor em rails numa startup X',
                                        educational_background: 'Matemático', occupation_area: @occupation_area,
                                        description: 'Recém formada, em busca de...', professional: @professional3)
            @project_application1 = ProjectApplication.create!(motivation: 'Trabalhei em ...', expected_conclusion: '1 mês',
                                                               weekly_hours: 10, expected_payment: 100, project: @project, professional: @professional1,
                                                               situation: :accepted)
            @project_application2 = ProjectApplication.create!(motivation: 'Trabalhava como ...', expected_conclusion: '3 semanas',
                                                               weekly_hours: 15, expected_payment: 150, project: @project, professional: @professional2,
                                                               situation: :rejected, reject_message: 'Não gostei do seu nome')
            @project_application3 = ProjectApplication.create!(motivation: 'Costumava trabalhar ...', expected_conclusion: '3 semanas',
                                                               weekly_hours: 15, expected_payment: 150, project: @project, professional: @professional3,
                                                               situation: :accepted)
            login_as @user, scope: :user
            visit root_path
            click_on 'Meus projetos'
            click_on @project.title
            click_on 'Visualizar time do projeto'

            expect(page).to have_content('Dono do projeto: otavio@user.com')
            expect(page).to have_link(@profile1.social_name)
            expect(page).to have_content('- Área de atuação: Dev')
            expect(page).to have_content(@profile1.description)
            expect(page).to have_link(@profile3.social_name)
            expect(page).to have_content(@profile3.description)
            expect(page).not_to have_link(@profile2.social_name)
            expect(page).not_to have_content(@profile2.description)
        end
    end

    context 'Professional' do
        it 'view the team for a project they are taking part on' do
            @user = User.create!(email: 'otavio@user.com', password: '123131')
            @project = Project.create!(title: 'Sistema de aluguel de imóveis',
                                       description: 'Projeto que visa criar uma aplicação para oferecer imóveis alugáveis em todo o estado de São Paulo',
                                       skills: 'Conhecimento em Rails, Web Design e segurança',
                                       date_limit: 20.days.from_now, work_regimen: :remote,
                                       hour_value: 300, user: @user, status: :open)
            @professional1 = Professional.create!(email: 'otavio@professional.com.br', password: 'ahudufgvya')
            @professional2 = Professional.create!(email: 'josé@professional.com.br', password: 'asufgyiadf')
            @professional3 = Professional.create!(email: 'alana@professional.com.br', password: 'ahfyhdajkbf')
            @occupation_area = OccupationArea.create!(name: 'Dev')
            @profile1 = Profile.create!(birth_date: 18.years.ago, full_name: 'Otávio Lins', 
                                       social_name: 'Otávio Augusto', prior_experience: 'Trabalhei como desenvolvedor em rails numa startup X',
                                       educational_background: 'Matemático', occupation_area: @occupation_area,
                                       description: 'Profissional em mud...', professional: @professional1)
            @profile2 = Profile.create!(birth_date: 18.years.ago, full_name: 'José Bezerra', 
                                        social_name: 'Flynn Rider', prior_experience: 'Trabalhei como desenvolvedor em rails numa startup X',
                                        educational_background: 'Matemático', occupation_area: @occupation_area,
                                        description: 'Esperto, aprendo rápido...', professional: @professional2)
            @profile3 = Profile.create!(birth_date: 18.years.ago, full_name: 'Alana Xeherazade', 
                                        social_name: 'Alana Xeherazade', prior_experience: 'Trabalhei como desenvolvedor em rails numa startup X',
                                        educational_background: 'Matemático', occupation_area: @occupation_area,
                                        description: 'Recém formada, em busca de...', professional: @professional3)
            @project_application1 = ProjectApplication.create!(motivation: 'Trabalhei em ...', expected_conclusion: '1 mês',
                                                               weekly_hours: 10, expected_payment: 100, project: @project, professional: @professional1,
                                                               situation: :accepted, acceptance_date: 5.days.ago)
            @project_application2 = ProjectApplication.create!(motivation: 'Trabalhava como ...', expected_conclusion: '3 semanas',
                                                               weekly_hours: 15, expected_payment: 150, project: @project, professional: @professional2,
                                                               situation: :rejected, reject_message: 'Não gostei do seu nome')
            @project_application3 = ProjectApplication.create!(motivation: 'Costumava trabalhar ...', expected_conclusion: '3 semanas',
                                                               weekly_hours: 15, expected_payment: 150, project: @project, professional: @professional3,
                                                               situation: :accepted, acceptance_date: 5.days.ago)  
                                                               
            login_as @professional3, scope: :professional
            visit root_path
            click_on 'Meus projetos'
            click_on @project.title
            click_on 'Clique aqui'

            expect(page).to have_content('Dono do projeto: otavio@user.com')
            expect(page).to have_link(@profile1.social_name)
            expect(page).to have_content('- Área de atuação: Dev')
            expect(page).to have_content(@profile1.description)
            expect(page).to have_link(@profile3.social_name)
            expect(page).to have_content(@profile3.description)
            expect(page).not_to have_link(@profile2.social_name)
            expect(page).not_to have_content(@profile2.description)
        end
    end
end