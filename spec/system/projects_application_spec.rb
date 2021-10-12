require 'rails_helper'

describe 'Projects application:' do
    context 'Professional applies to a project' do
        it 'successfully' do
            user = User.create!(email: 'otavio@user.com', password: '123131')
            @project = Project.create!(title: 'Sistema de aluguel de imóveis',
                                       description: 'Projeto que visa criar uma aplicação para oferecer imóveis alugáveis em todo o estado de São Paulo',
                                       skills: 'Conhecimento em Rails, Web Design e segurança',
                                       date_limit: 20.days.from_now, work_regimen: :remoto,
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

            expect(page).to have_content('Trabalhei como desenvolvedor em rails numa startup por 5 anos...')
            expect(page).to have_content('Valor que espera receber por hora: R$ 250,00')
            expect(page).to have_content('Horas semanais que pretende trabalhar no projeto: 20 horas')
            expect(page).to have_content('Expectativa de conclusão: 1 mês')
            expect(page).to have_content('Proposta enviada com sucesso')
        end

        it 'unsuccessfully' do
            user = User.create!(email: 'otavio@user.com', password: '123131')
            @project = Project.create!(title: 'Sistema de aluguel de imóveis',
                                       description: 'Projeto que visa criar uma aplicação para oferecer imóveis alugáveis em todo o estado de São Paulo',
                                       skills: 'Conhecimento em Rails, Web Design e segurança',
                                       date_limit: 20.days.from_now, work_regimen: :remoto,
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
            click_on 'Enviar proposta para esse projeto'

            expect(ProjectApplication.count).to eq(0)
            expect(page).to have_content('Porque se acha capaz de pegar esse projeto? é obrigatório(a)')
            expect(page).to have_content('Valor que espera receber não pode ser maior que o valor máximo por hora')
            expect(page).to have_content('Expectativa de conclusão é obrigatório(a)')
        end
    end
    context 'Professional views his applications' do
        it 'successfully' do
        end
    end
end