require 'rails_helper'

describe 'Projects application:' do
    context 'Professional:' do
        it 'applies to a project successfully' do
            user = User.create!(email: 'otavio@user.com', password: '123131')
            @project = Project.create!(title: 'Sistema de aluguel de imóveis',
                                       description: 'Projeto que visa criar uma aplicação para oferecer imóveis alugáveis em todo o estado de São Paulo',
                                       skills: 'Conhecimento em Rails, Web Design e segurança',
                                       date_limit: 20.days.from_now, work_regimen: :remote,
                                       hour_value: 300, user: user, status: :open)
            @professional = Professional.create!(email: 'otavio@professional.com.br', password: 'ahudufgvya')
            @occupation_area = OccupationArea.create!(name: 'Dev')
            @profile = Profile.create!(birth_date: 18.years.ago, full_name: 'Otávio Lins', 
                                       social_name: 'Otávio Augusto', prior_experience: 'Trabalhei como desenvolvedor em rails numa startup X',
                                       educational_background: 'Matemático', occupation_area: @occupation_area,
                                       description: 'Profissional em mud...', professional: @professional)
        
            login_as @professional, scope: :professional
            visit root_path
            click_on @project.title

            fill_in 'Porque se acha capaz de pegar esse projeto?', with: 'Trabalhei como desenvolvedor em rails numa startup por 5 anos...'
            fill_in 'Valor que espera receber por hora', with: 250
            fill_in 'Horas semanais que pretende trabalhar no projeto', with: 20
            fill_in 'Expectativa de conclusão', with: '1 mês'
            click_on 'Enviar proposta'

            expect(page).to have_link(@project.title)
            expect(page).to have_content('Porque se acha capaz de pegar esse projeto? Trabalhei como desenvolvedor em rails numa startup por 5 anos...')
            expect(page).to have_content('Valor que espera receber por hora: R$ 250,00')
            expect(page).to have_content('Horas semanais que pretende trabalhar no projeto: 20 horas')
            expect(page).to have_content('Expectativa de conclusão: 1 mês')
            expect(page).to have_content('Status: Em análise')
            expect(page).to have_content('Proposta enviada com sucesso')
        end

        it 'applies to a project unsuccessfully' do
            user = User.create!(email: 'otavio@user.com', password: '123131')
            @project = Project.create!(title: 'Sistema de aluguel de imóveis',
                                       description: 'Projeto que visa criar uma aplicação para oferecer imóveis alugáveis em todo o estado de São Paulo',
                                       skills: 'Conhecimento em Rails, Web Design e segurança',
                                       date_limit: 20.days.from_now, work_regimen: :remote,
                                       hour_value: 300, user: user, status: :open)
            @professional = Professional.create!(email: 'otavio@professional.com.br', password: 'ahudufgvya')
            @occupation_area = OccupationArea.create!(name: 'Dev')
            @profile = Profile.create!(birth_date: 18.years.ago, full_name: 'Otávio Lins', 
                                       social_name: 'Otávio Augusto', prior_experience: 'Trabalhei como desenvolvedor em rails numa startup X',
                                       educational_background: 'Matemático', occupation_area: @occupation_area,
                                       description: 'Profissional em mud...', professional: @professional)
        
            login_as @professional, scope: :professional
            visit root_path
            click_on @project.title
            fill_in 'Valor que espera receber por hora', with: 500
            fill_in 'Horas semanais que pretende trabalhar no projeto', with: 20
            click_on 'Enviar proposta'

            expect(ProjectApplication.count).to eq(0)
            expect(page).to have_content('Porque se acha capaz de pegar esse projeto? é obrigatório(a)')
            expect(page).to have_content('Expectativa de conclusão é obrigatório(a)')
            expect(page).to have_content('Valor que espera receber por hora não pode ser maior que o valor máximo por hora estipulado')
        end

        it 'cannot make a second application to the same project' do
            user = User.create!(email: 'otavio@user.com', password: '123131')
            @project = Project.create!(title: 'Sistema de aluguel de imóveis',
                                       description: 'Projeto que visa criar uma aplicação para oferecer imóveis alugáveis em todo o estado de São Paulo',
                                       skills: 'Conhecimento em Rails, Web Design e segurança',
                                       date_limit: 20.days.from_now, work_regimen: :remote,
                                       hour_value: 300, user: user, status: :open)
            @professional = Professional.create!(email: 'otavio@professional.com.br', password: 'ahudufgvya')
            @occupation_area = OccupationArea.create!(name: 'Dev')
            @profile = Profile.create!(birth_date: 18.years.ago, full_name: 'Otávio Lins', 
                                       social_name: 'Otávio Augusto', prior_experience: 'Trabalhei como desenvolvedor em rails numa startup X',
                                       educational_background: 'Matemático', occupation_area: @occupation_area,
                                       description: 'Profissional em mud...', professional: @professional)
            @project_application = ProjectApplication.create!(motivation: 'Trabalhei em ...', expected_conclusion: '1 mês',
                                                               weekly_hours: 10, expected_payment: 100, project: @project, professional: @professional,
                                                               situation: :analysis)
        
            login_as @professional, scope: :professional
            visit root_path
            click_on @project.title

            expect(page).to have_content('Você já fez uma proposta para esse projeto.')
            expect(page).not_to have_content('Enviar uma proposta para esse projeto.')
        end

        it 'views his applications successfully' do
            @user = User.create!(email: 'otavio@user.com', password: '123131')
            @project = Project.create!(title: 'Sistema de aluguel de imóveis',
                                       description: 'Projeto que visa criar uma aplicação para oferecer imóveis alugáveis em todo o estado de São Paulo',
                                       skills: 'Conhecimento em Rails, Web Design e segurança',
                                       date_limit: 20.days.from_now, work_regimen: :remote,
                                       hour_value: 300, user: @user, status: :open)
            @professional1 = Professional.create!(email: 'otavio@professional.com.br', password: 'ahudufgvya')
            @professional2 = Professional.create!(email: 'josé@professional.com.br', password: 'asufgyiadf')
            @occupation_area = OccupationArea.create!(name: 'Dev')
            @profile1 = Profile.create!(birth_date: 18.years.ago, full_name: 'Otávio Lins', 
                                       social_name: 'Otávio Augusto', prior_experience: 'Trabalhei como desenvolvedor em rails numa startup X',
                                       educational_background: 'Matemático', occupation_area: @occupation_area,
                                       description: 'Profissional em mud...', professional: @professional1)
            @profile2 = Profile.create!(birth_date: 18.years.ago, full_name: 'José Bezerra', 
                                       social_name: 'Flynn Rider', prior_experience: 'Trabalhei como desenvolvedor em rails numa startup X',
                                       educational_background: 'Matemático', occupation_area: @occupation_area,
                                       description: 'Profissional em mud...', professional: @professional2)
            @project_application1 = ProjectApplication.create!(motivation: 'Trabalhei em ...', expected_conclusion: '1 mês',
                                                               weekly_hours: 10, expected_payment: 100, project: @project, professional: @professional1,
                                                               situation: :analysis)
            @project_application2 = ProjectApplication.create!(motivation: 'Trabalhava como ...', expected_conclusion: '3 semanas',
                                                               weekly_hours: 15, expected_payment: 150, project: @project, professional: @professional2,
                                                               situation: :analysis)
            
            login_as @professional1, scope: :professional
            visit root_path
            click_on 'Meus projetos'

            expect(page).to have_link(@project.title)
            expect(page).to have_content(@project_application1.motivation)
            expect(page).to have_content('R$ 100,00')
            expect(page).to have_content(@project_application1.expected_conclusion)
            expect(page).to have_content(@project_application1.weekly_hours)
            expect(page).not_to have_content(@project_application2.motivation)
            expect(page).not_to have_content('R$ 150,00')
            expect(page).not_to have_content(@project_application2.expected_conclusion)
            expect(page).not_to have_content(@project_application2.weekly_hours)
        end
    end
    context 'User:' do
        it 'views the applications for his projects' do
            @user1 = User.create!(email: 'otavio@user.com', password: '123131')
            @project1 = Project.create!(title: 'Sistema de aluguel de imóveis',
                                       description: 'Projeto que visa criar uma aplicação para oferecer imóveis alugáveis em todo o estado de São Paulo',
                                       skills: 'Conhecimento em Rails, Web Design e segurança',
                                       date_limit: 20.days.from_now, work_regimen: :remote,
                                       hour_value: 300, user: @user1, status: :open)
            @user2 = User.create!(email:'Alvin@user.com', password: '154874')
            @project2 = Project.create!(title: 'Sistema de aluguel de carros',
                                        description: 'Projeto que visa criar uma aplicação para oferecer carros alugáveis em todo o estado de São Paulo',
                                        skills: 'Conhecimento em Rails, Web Design e segurança',
                                        date_limit: 20.days.from_now, work_regimen: :in_person,
                                        hour_value: 300, user: @user2, status: :open)
            @professional = Professional.create!(email: 'otavio@professional.com.br', password: 'ahudufgvya')
            @occupation_area = OccupationArea.create!(name: 'Dev')
            @profile = Profile.create!(birth_date: 18.years.ago, full_name: 'Otávio Lins', 
                                       social_name: 'Otávio Augusto', prior_experience: 'Trabalhei como desenvolvedor em rails numa startup X',
                                       educational_background: 'Matemático', occupation_area: @occupation_area,
                                       description: 'Profissional em mud...', professional: @professional) 
            @project_application1 = ProjectApplication.create!(motivation: 'Trabalhei em ...', expected_conclusion: '1 mês',
                                        weekly_hours: 10, expected_payment: 100, project: @project1, professional: @professional,
                                        situation: :analysis)
            @project_application2 = ProjectApplication.create!(motivation: 'Trabalhava como ...', expected_conclusion: '3 semanas',
                                        weekly_hours: 15, expected_payment: 150, project: @project2, professional: @professional,
                                        situation: :analysis)

            login_as @user1, scope: :user
            visit root_path
            click_on 'Meus projetos'
            click_on 'Sistema de aluguel de imóveis'
            click_on 'Ver propostas para esse projeto'

            expect(page).to have_content('Propostas para Sistema de aluguel de imóveis')
            expect(page).to have_link(@profile.social_name)
            expect(page).to have_content(@project_application1.motivation)
            expect(page).to have_content(@project_application1.weekly_hours)
            expect(page).to have_content(@project_application1.expected_conclusion)
            expect(page).to have_content('R$ 100,00')
            expect(page).not_to have_content(@project_application2.motivation)
            expect(page).not_to have_content(@project_application2.weekly_hours)
            expect(page).not_to have_content(@project_application2.expected_conclusion)
            expect(page).not_to have_content('R$ 150,00')
        end

        it 'can access professional profile through his application and view his projects' do
            @user1 = User.create!(email: 'otavio@user.com', password: '123131')
            @project1 = Project.create!(title: 'Sistema de aluguel de imóveis',
                                       description: 'Projeto que visa criar uma aplicação para oferecer imóveis alugáveis em todo o estado de São Paulo',
                                       skills: 'Conhecimento em Rails, Web Design e segurança',
                                       date_limit: 20.days.from_now, work_regimen: :remote,
                                       hour_value: 300, user: @user1, status: :open)
            @user2 = User.create!(email:'Alvin@user.com', password: '154874')
            @project2 = Project.create!(title: 'Sistema de aluguel de carros',
                                        description: 'Projeto que visa criar uma aplicação para oferecer carros alugáveis em todo o estado de São Paulo',
                                        skills: 'Conhecimento em Rails, Web Design e segurança',
                                        date_limit: 20.days.from_now, work_regimen: :in_person,
                                        hour_value: 300, user: @user2, status: :open)                           
            @professional = Professional.create!(email: 'otavio@professional.com.br', password: 'ahudufgvya')
            @professional2 = Professional.create!(email: 'Alvin@professional.com.br', password: 'dhagfdan')
            @occupation_area = OccupationArea.create!(name: 'Dev')
            @profile = Profile.create!(birth_date: 18.years.ago, full_name: 'Otávio Lins', 
                                       social_name: 'Otávio Augusto', prior_experience: 'Trabalhei como desenvolvedor em rails numa startup X',
                                       educational_background: 'Matemático', occupation_area: @occupation_area,
                                       description: 'Profissional em mud...', professional: @professional)
            @profile2 = Profile.create!(birth_date: 18.years.ago, full_name: 'José Bezerra', 
                                       social_name: 'Flynn Rider', prior_experience: 'Trabalhei como desenvolvedor em rails numa startup X',
                                       educational_background: 'Matemático', occupation_area: @occupation_area,
                                       description: 'Profissional em mud...', professional: @professional2) 
            @project_application1 = ProjectApplication.create!(motivation: 'Trabalhei em ...', expected_conclusion: '1 mês',
                                        weekly_hours: 10, expected_payment: 100, project: @project1, professional: @professional,
                                        situation: :rejected)
            @project_application2 = ProjectApplication.create!(motivation: 'Trabalhava como ...', expected_conclusion: '3 semanas',
                                        weekly_hours: 15, expected_payment: 150, project: @project2, professional: @professional,
                                        situation: :accepted)
            @project_application3 = ProjectApplication.create!(motivation: 'Tenho muita experiência ...', expected_conclusion: '2 meses',
                                        weekly_hours: 5, expected_payment: 175, project: @project1, professional: @professional2,
                                        situation: :accepted)           
            login_as @user1, scope: :user
            
            visit root_path
            @project1.finished!
            @project2.finished!
            click_on 'Meus projetos'
            click_on 'Sistema de aluguel de imóveis'
            click_on 'Ver propostas para esse projeto'        
            click_on @profile.social_name

            expect(page).to have_content('Perfil de Otávio')
            expect(page).to have_content('Projetos em que já atuou')
            expect(page).not_to have_content('Esse profissional ainda não atuou em nenhum projeto')
            expect(page).to have_link(@project2.title)
            expect(page).to have_content(@user2.email)
            expect(page).not_to have_link(@project1.title)
        end

        it 'can accept an application' do
            @user1 = User.create!(email: 'otavio@user.com', password: '123131')
            @project1 = Project.create!(title: 'Sistema de aluguel de imóveis',
                                       description: 'Projeto que visa criar uma aplicação para oferecer imóveis alugáveis em todo o estado de São Paulo',
                                       skills: 'Conhecimento em Rails, Web Design e segurança',
                                       date_limit: 20.days.from_now, work_regimen: :remote,
                                       hour_value: 300, user: @user1, status: :open)        

            @professional1 = Professional.create!(email: 'otavio@professional.com.br', password: 'ahudufgvya')
            @occupation_area = OccupationArea.create!(name: 'Dev')
            @profile1 = Profile.create!(birth_date: 18.years.ago, full_name: 'Otávio Lins', 
                                       social_name: 'Otávio Augusto', prior_experience: 'Trabalhei como desenvolvedor em rails numa startup X',
                                       educational_background: 'Matemático', occupation_area: @occupation_area,
                                       description: 'Profissional em mud...', professional: @professional1)
            @project_application1 = ProjectApplication.create!(motivation: 'Trabalhei em ...', expected_conclusion: '1 mês',
                                        weekly_hours: 10, expected_payment: 100, project: @project1, professional: @professional1,
                                        situation: :analysis)

            login_as @user1, scope: :user
            visit root_path
            click_on 'Meus projetos'
            click_on 'Sistema de aluguel de imóveis'
            click_on 'Ver propostas para esse projeto'
            click_on 'Aceitar proposta'
            
            expect(page).to have_content('Propostas para Sistema de aluguel de imóveis')
            expect(page).to have_link(@profile1.social_name)
            expect(page).to have_content(@project_application1.motivation)
            expect(page).to have_content(@project_application1.weekly_hours)
            expect(page).to have_content(@project_application1.expected_conclusion)
            expect(page).to have_content('R$ 100,00')
            expect(page).to have_content('Status: Aceita')
        end
    end
end