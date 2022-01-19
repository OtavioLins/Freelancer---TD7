require 'rails_helper'

describe 'Closing and ending projects' do
  include ActiveSupport::Testing::TimeHelpers
  context 'Closing:' do
    it 'professional cant see a closed project on homepage' do
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

      travel_to 20.days.from_now do
        login_as @professional, scope: :professional
        visit root_path
      end

      expect(page).not_to have_link('Sistema de aluguel de imóveis')
    end

    it 'professional cant see a closed project through his applications if his application wasnt accepted' do
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
      @project_application = ProjectApplication.create!(motivation: 'Trabalhei em ...', expected_conclusion: '1 mês',
                                                        weekly_hours: 10, expected_payment: 100, project: @project, professional: @professional,
                                                        situation: :analysis)
      travel_to 20.days.from_now do
        login_as @professional, scope: :professional
        visit root_path
        click_on 'Meus projetos'
        click_on 'Sistema de aluguel de imóveis'
      end
      expect(current_path).to eq(my_applications_path)
      expect(page).to have_content('Você não tem mais acesso a esse projeto')
    end

    it 'manually' do
      @user = User.create!(email: 'otavio@user.com', password: '123131')
      @project = Project.create!(title: 'Sistema de aluguel de imóveis',
                                 description: 'Projeto que visa criar uma aplicação para oferecer imóveis alugáveis em todo o estado de São Paulo',
                                 skills: 'Conhecimento em Rails, Web Design e segurança',
                                 date_limit: 20.days.from_now, work_regimen: :remote,
                                 hour_value: 300, user: @user, status: :open)

      login_as @user, scope: :user
      visit root_path
      click_on 'Meus projetos'
      click_on 'Encerrar recebimento de propostas'
      click_on 'Confirmar'

      expect(page).to have_link('Sistema de aluguel de imóveis')
      expect(page).to have_content('Fechado para propostas')
    end

    it 'manually, while rejecting all the project_applications that were in analysis' do
      @user = User.create!(email: 'otavio@user.com', password: '123131')
      @project = Project.create!(title: 'Sistema de aluguel de imóveis',
                                 description: 'Projeto que visa criar uma aplicação para oferecer imóveis alugáveis em todo o estado de São Paulo',
                                 skills: 'Conhecimento em Rails, Web Design e segurança',
                                 date_limit: 20.days.from_now, work_regimen: :remote,
                                 hour_value: 300, user: @user, status: :open)
      @professional = Professional.create!(email: 'otavio@professional.com.br', password: 'ahudufgvya')
      @professional2 = Professional.create!(email: 'josé@professional.com.br', password: 'asufgyiadf')
      @occupation_area = OccupationArea.create!(name: 'Dev')
      @profile = Profile.create!(birth_date: 18.years.ago, full_name: 'Otávio Lins',
                                 social_name: 'Otávio Augusto', prior_experience: 'Trabalhei como desenvolvedor em rails numa startup X',
                                 educational_background: 'Matemático', occupation_area: @occupation_area,
                                 description: 'Profissional em mud...', professional: @professional)
      @profile2 = Profile.create!(birth_date: 18.years.ago, full_name: 'José Bezerra',
                                  social_name: 'Flynn Rider', prior_experience: 'Trabalhei como desenvolvedor em rails numa startup X',
                                  educational_background: 'Matemático', occupation_area: @occupation_area,
                                  description: 'Profissional em mud...', professional: @professional2)
      @project_application = ProjectApplication.create!(motivation: 'Trabalhei em ...', expected_conclusion: '1 mês',
                                                        weekly_hours: 10, expected_payment: 100, project: @project, professional: @professional,
                                                        situation: :accepted, acceptance_date: Date.today)
      @project_application2 = ProjectApplication.create!(motivation: 'Trabalhava como ...', expected_conclusion: '3 semanas',
                                                         weekly_hours: 15, expected_payment: 150, project: @project, professional: @professional2,
                                                         situation: :analysis)

      login_as @user, scope: :user
      visit root_path
      click_on 'Meus projetos'
      click_on 'Encerrar recebimento de propostas'
      click_on 'Confirmar'

      expect(page).to have_link('Sistema de aluguel de imóveis')
      expect(page).to have_content('Fechado para propostas')
      expect(@project_application.accepted?).to eq(true)
      expect(@project_application.reload.accepted?).to eq(true)
      expect(@project_application2.reload.reject_message).to eq(
        'Esse projeto está agora fechado para propostas'
      )
      expect(@project_application2.reload.rejected?).to eq(true)
    end
  end
  context 'Ending:' do
    it 'Declare a closed project as finished' do
      @user = User.create!(email: 'otavio@user.com', password: '123131')
      @project = Project.create!(title: 'Sistema de aluguel de imóveis',
                                 description: 'Projeto que visa criar uma aplicação para oferecer imóveis alugáveis em todo o estado de São Paulo',
                                 skills: 'Conhecimento em Rails, Web Design e segurança',
                                 date_limit: 20.days.from_now, work_regimen: :remote,
                                 hour_value: 300, user: @user, status: :open)

      login_as @user, scope: :user
      visit root_path
      click_on 'Meus projetos'
      click_on 'Encerrar recebimento de propostas'
      click_on 'Confirmar'
      click_on 'Encerrar projeto'
      click_on 'Confirmar'

      expect(page).to have_content('Status do projeto: Encerrado')
    end

    it 'cant see the finish link if project isnt closed' do
      @user = User.create!(email: 'otavio@user.com', password: '123131')
      @project = Project.create!(title: 'Sistema de aluguel de imóveis',
                                 description: 'Projeto que visa criar uma aplicação para oferecer imóveis alugáveis em todo o estado de São Paulo',
                                 skills: 'Conhecimento em Rails, Web Design e segurança',
                                 date_limit: 20.days.from_now, work_regimen: :remote,
                                 hour_value: 300, user: @user, status: :open)

      login_as @user, scope: :user
      visit root_path
      click_on 'Meus projetos'

      expect(page).not_to have_link('Encerrar projeto')
    end
  end
end
