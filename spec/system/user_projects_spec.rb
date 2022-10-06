# frozen_string_literal: true

require 'rails_helper'

describe 'Users projects' do
  include ActiveSupport::Testing::TimeHelpers
  context 'Creation:' do
    it 'Successfully' do
      user = User.create!(email: 'otavio@user.com.br', password: '123456789')
      data = 5.days.from_now
      login_as user, scope: :user
      visit root_path
      click_on 'Cadastrar um novo projeto'
      fill_in 'Título', with: 'Sistema de aluguel de imóveis'
      fill_in 'Descrição', with: 'Projeto que visa criar uma aplicação para
            oferecer imóveis alugáveis em todo o estado de São Paulo'
      fill_in 'Habilidades buscadas', with: 'Conhecimento em Rails, Web Design e segurança'
      fill_in 'Valor máximo por hora', with: '300'
      fill_in 'Data limite para propostas', with: data
      select 'Remoto', from: 'Regime de trabalho'
      click_on 'Finalizar'

      expect(page).to have_content('Sistema de aluguel de imóveis')
      expect(page).to have_content('Projeto que visa criar uma aplicação para oferecer imóveis alugáveis em todo o estado de São Paulo')
      expect(page).to have_content('Habilidades buscadas: Conhecimento em Rails, Web Design e segurança')
      expect(page).to have_content('Valor máximo por hora: R$ 300,00')
      expect(page).to have_content('Regime de trabalho: Remoto')
    end

    it 'Unsuccessfully - Left everything blank' do
      user = User.create!(email: 'otavio@user.com.br', password: '123456789')
      login_as user, scope: :user
      visit root_path
      click_on 'Cadastrar um novo projeto'
      click_on 'Finalizar'

      expect(page).to have_content('Título é obrigatório(a)')
      expect(page).to have_content('Descrição é obrigatório(a)')
      expect(page).to have_content('Habilidades buscadas é obrigatório(a)')
      expect(page).to have_content('Valor máximo por hora é obrigatório(a)')
      expect(page).to have_content('Data limite para propostas é obrigatório(a)')
    end

    it 'Unsuccessfully - Created a date_limit in the past and a negative value per hour' do
      user = User.create!(email: 'otavio@user.com.br', password: '123456789')
      login_as user, scope: :user
      visit root_path
      click_on 'Cadastrar um novo projeto'
      fill_in 'Título', with: 'Sistema de aluguel de imóveis'
      fill_in 'Descrição', with: 'Projeto que visa criar uma aplicação para
            oferecer imóveis alugáveis em todo o estado de São Paulo'
      fill_in 'Habilidades buscadas', with: 'Conhecimento em Rails, Web Design e segurança'
      fill_in 'Valor máximo por hora', with: '-300'
      fill_in 'Data limite para propostas', with: 5.days.ago
      select 'Remoto', from: 'Regime de trabalho'
      click_on 'Finalizar'

      expect(page).to have_content('Data limite para propostas não pode ser no passado')
      expect(page).to have_content('Valor máximo por hora deve ser um número positivo')
    end
  end
  context 'Visualization:' do
    it 'through Meus projetos - user can see both open,closed and finished projects' do
      user = User.create!(email: 'otavio@user.com', password: '123131')
      user2 = User.create!(email: 'jane@user.com', password: '123546')
      @project1 = Project.create!(title: 'Sistema de aluguel de imóveis',
                                  description: 'Projeto que visa criar uma aplicação para oferecer imóveis alugáveis em todo o estado de São Paulo',
                                  skills: 'Conhecimento em Rails, Web Design e segurança',
                                  date_limit: 20.days.from_now, work_regimen: :remote,
                                  hour_value: 300, user: user, status: :open)
      @project2 = Project.create!(title: 'Sistema de aluguel de carros',
                                  description: 'Projeto que visa criar uma aplicação para oferecer carros alugáveis em todo o estado de São Paulo',
                                  skills: 'Conhecimento em Rails, Web Design e segurança',
                                  date_limit: 10.days.from_now, work_regimen: :remote,
                                  hour_value: 300, user: user, status: :open)
      @project3 = Project.create!(title: 'Sistema de aluguel de iates',
                                  description: 'Projeto que visa criar uma aplicação para oferecer imóveis alugáveis em todo o estado de São Paulo',
                                  skills: 'Conhecimento em Rails, Web Design e segurança',
                                  date_limit: 3.days.from_now, work_regimen: :remote,
                                  hour_value: 300, user: user2, status: :finished)

      travel_to 15.days.from_now do
        login_as user, scope: :user
        visit root_path
        click_on 'Meus projetos'
      end

      expect(page).to have_content('Meus projetos')
      expect(page).to have_link(@project1.title)
      expect(page).to have_content("Descrição: #{@project1.description}")
      expect(page).to have_content("Habilidades buscadas: #{@project1.skills}")
      expect(page).to have_content('Status: Aberto para propostas')
      expect(page).to have_content('Meus projetos')
      expect(page).to have_link(@project2.title)
      expect(page).to have_content("Descrição: #{@project2.description}")
      expect(page).to have_content("Habilidades buscadas: #{@project2.skills}")
      expect(page).to have_content('Status: Fechado para propostas')
      expect(page).to have_content('Meus projetos')
      expect(page).not_to have_link(@project3.title)
    end

    it 'through Professional homepage - professional can only see open projects' do
      @project1 = create(:project, title: 'Sistema de aluguel de imóveis',
                                   description: 'Projeto que visa criar uma aplicação para oferecer imóveis...')
      @project2 = create(:project, title: 'Sistema de aluguel de carros',
                                   description: 'Projeto que visa criar uma aplicação para oferecer carros...',
                                   status: :closed)
      @project3 = create(:project, title: 'Sistema de aluguel de iates',
                                   description: 'Projeto que visa criar uma aplicação para oferecer iates...',
                                   status: :finished)
      @professional = create(:professional, complete_profile: true)

      login_as @professional, scope: :professional
      visit root_path

      expect(page).to have_link(@project1.title)
      expect(page).to have_content(@project1.description)
      expect(page).to have_content(@project1.skills)
      expect(page).not_to have_link(@project2.title)
      expect(page).not_to have_content(@project2.description)
      expect(page).not_to have_link(@project3.title)
      expect(page).not_to have_content(@project3.description)
    end
  end
end
