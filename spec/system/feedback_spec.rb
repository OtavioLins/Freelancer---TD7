# frozen_string_literal: true

require 'rails_helper'

describe 'Feedbacks' do
  context 'User:' do
    it 'gives feedback to a professional after a project is finished' do
      @user = User.create!(email: 'otavio@user.com', password: '123131')
      @project = Project.create!(title: 'Sistema de aluguel de imóveis',
                                 description: 'Projeto que visa criar uma aplicação para oferecer imóveis alugáveis em todo o estado de São Paulo',
                                 skills: 'Conhecimento em Rails, Web Design e segurança',
                                 date_limit: 20.days.from_now, work_regimen: :remote,
                                 hour_value: 300, user: @user, status: :finished)
      @professional = Professional.create!(email: 'otavio@professional.com.br', password: 'ahudufgvya')
      @occupation_area = OccupationArea.create!(name: 'Dev')
      @profile = Profile.create!(birth_date: 18.years.ago, full_name: 'Otávio Lins',
                                 social_name: 'Otávio Augusto', prior_experience: 'Trabalhei como desenvolvedor em rails numa startup X',
                                 educational_background: 'Matemático', occupation_area: @occupation_area,
                                 description: 'Profissional em mud...', professional: @professional)
      @project_application = ProjectApplication.create!(motivation: 'Trabalhei em ...', expected_conclusion: '1 mês',
                                                        weekly_hours: 10, expected_payment: 100, project: @project, professional: @professional,
                                                        situation: :accepted, acceptance_date: Date.today)

      login_as @user, scope: :user
      visit root_path
      click_on 'Meus projetos'
      click_on 'Sistema de aluguel de imóveis'
      click_on 'Visualizar time do projeto'
      click_on 'Dar feedback para esse profissional'
      fill_in 'Nota', with: 4
      fill_in 'Comentário', with: 'Bom professional, porém atrasou um pouco a entrega de sua parte'
      click_on 'Enviar feedback'

      # expect(current_path).to eq(profile_path(@professional))
      expect(page).to have_content('Média dos feedbacks recebidos: 4')
      expect(page).to have_link('Ver feedbacks desse profissional')
    end

    it 'tries do give feedback to a professional after a project is finished, but leave fields blank' do
      @user = User.create!(email: 'otavio@user.com', password: '123131')
      @project = Project.create!(title: 'Sistema de aluguel de imóveis',
                                 description: 'Projeto que visa criar uma aplicação para oferecer imóveis alugáveis em todo o estado de São Paulo',
                                 skills: 'Conhecimento em Rails, Web Design e segurança',
                                 date_limit: 20.days.from_now, work_regimen: :remote,
                                 hour_value: 300, user: @user, status: :finished)
      @professional = Professional.create!(email: 'otavio@professional.com.br', password: 'ahudufgvya')
      @occupation_area = OccupationArea.create!(name: 'Dev')
      @profile = Profile.create!(birth_date: 18.years.ago, full_name: 'Otávio Lins',
                                 social_name: 'Otávio Augusto', prior_experience: 'Trabalhei como desenvolvedor em rails numa startup X',
                                 educational_background: 'Matemático', occupation_area: @occupation_area,
                                 description: 'Profissional em mud...', professional: @professional)
      @project_application = ProjectApplication.create!(motivation: 'Trabalhei em ...', expected_conclusion: '1 mês',
                                                        weekly_hours: 10, expected_payment: 100, project: @project, professional: @professional,
                                                        situation: :accepted, acceptance_date: Date.today)

      login_as @user, scope: :user
      visit root_path
      click_on 'Meus projetos'
      click_on 'Sistema de aluguel de imóveis'
      click_on 'Visualizar time do projeto'
      click_on 'Dar feedback para esse profissional'
      fill_in 'Nota', with: '15'
      click_on 'Enviar feedback'

      expect(page).to have_content('Nota deve ser um número inteiro entre 1 e 5')
      expect(page).to have_content('Comentário é obrigatório(a)')
      expect(UserFeedback.count).to eq(0)
    end

    it 'views a feedback on an professional profile' do
      @user = User.create!(email: 'otavio@user.com', password: '123131')
      @project = Project.create!(title: 'Sistema de aluguel de imóveis',
                                 description: 'Projeto que visa criar uma aplicação para oferecer imóveis alugáveis em todo o estado de São Paulo',
                                 skills: 'Conhecimento em Rails, Web Design e segurança',
                                 date_limit: 20.days.from_now, work_regimen: :remote,
                                 hour_value: 300, user: @user, status: :finished)
      @professional = Professional.create!(email: 'otavio@professional.com.br', password: 'ahudufgvya')
      @occupation_area = OccupationArea.create!(name: 'Dev')
      @profile = Profile.create!(birth_date: 18.years.ago, full_name: 'Otávio Lins',
                                 social_name: 'Otávio Augusto', prior_experience: 'Trabalhei como desenvolvedor em rails numa startup X',
                                 educational_background: 'Matemático', occupation_area: @occupation_area,
                                 description: 'Profissional em mud...', professional: @professional)
      @project_application = ProjectApplication.create!(motivation: 'Trabalhei em ...', expected_conclusion: '1 mês',
                                                        weekly_hours: 10, expected_payment: 100, project: @project, professional: @professional,
                                                        situation: :accepted, acceptance_date: Date.today)
      @user_feedback = UserFeedback.create!(grade: 5, comment: 'Profissional muito bem apessoado', user: @user,
                                            professional: @professional, project: @project)
      @user2 = User.create!(email: 'jane@doe.com.br', password: 'ahufgydfajk')

      login_as @user2, scope: :user
      visit root_path
      click_on @profile.social_name
      click_on 'Ver feedbacks desse profissional'

      expect(page).to have_content('Projeto: Sistema de aluguel de imóveis')
      expect(page).to have_content('Dono do projeto: otavio@user.com')
      expect(page).to have_content('Nota: 5')
      expect(page).to have_content('Profissional muito bem apessoado')
    end
  end
end
