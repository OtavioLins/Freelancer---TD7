# frozen_string_literal: true

require 'rails_helper'

describe 'Filtering projects' do
  context 'by work regimen' do
    it 'successfully' do
    end
  end

  context 'by a key word' do
    # it 'successfully' do
    #   @user = User.create!(email: 'otavio@user.com', password: '123131')
    #   @project1 = Project.create!(title: 'Projeto de aluguel de imóveis',
    #                               description: 'Sistema que visa criar uma aplicação para oferecer imóveis alugáveis em todo o estado de São Paulo',
    #                               skills: 'Conhecimento em Rails, Web Design e segurança',
    #                               date_limit: 20.days.from_now, work_regimen: :remote,
    #                               hour_value: 300, user: @user, status: :open)
    #   @project2 = Project.create!(title: 'Sistema de aluguel de carros',
    #                               description: 'projeto que visa criar uma aplicação para oferecer carros alugáveis em todo o estado de São Paulo',
    #                               skills: 'Conhecimento em Rails, Web Design e segurança',
    #                               date_limit: 20.days.from_now, work_regimen: :in_person,
    #                               hour_value: 300, user: @user, status: :open)
    #   @project3 = Project.create!(title: 'Sistema de aluguel de motos',
    #                               description: 'Sistema que visa criar uma aplicação para oferecer carros alugáveis em todo o estado de São Paulo',
    #                               skills: 'Conhecimento em Rails, Web Design e segurança',
    #                               date_limit: 20.days.from_now, work_regimen: :in_person,
    #                               hour_value: 300, user: @user, status: :open)
    #   @project4 = Project.create!(title: 'Sistema de aluguel de iates',
    #                               description: 'Sistema que visa criar uma aplicação para oferecer carros alugáveis em todo o estado de São Paulo',
    #                               skills: 'Conhecimento em Rails, Web Design e segurança',
    #                               date_limit: 20.days.from_now, work_regimen: :in_person,
    #                               hour_value: 300, user: @user, status: :closed)
    #   @professional = Professional.create!(email: 'otavio@professional.com.br', password: 'ahudufgvya')
    #   @occupation_area = OccupationArea.create!(name: 'Dev')
    #   @profile = Profile.create!(birth_date: 18.years.ago, full_name: 'Otávio Lins',
    #                              social_name: 'Otávio Augusto', prior_experience: 'Trabalhei como desenvolvedor em rails numa startup X',
    #                              educational_background: 'Matemático', occupation_area: @occupation_area,
    #                              description: 'Profissional em mud...', professional: @professional)

    #   login_as @professional, scope: :professional
    #   visit root_path
    #   fill_in 'Texto que deseja buscar', with: 'Projeto'
    #   click_on 'Buscar'

    #   expect(page).to have_link('Sistema de aluguel de carros')
    #   expect(page).to have_link('Projeto de aluguel de imóveis')
    #   expect(page).not_to have_link('Sistema de aluguel de motos')
    #   expect(page).not_to have_link('Sistema de aluguel de iates')
    # end

    it 'unsuccessfully: no projects match the key word' do
      @user = User.create!(email: 'otavio@user.com', password: '123131')
      @project1 = Project.create!(title: 'Projeto de aluguel de imóveis',
                                  description: 'Sistema que visa criar uma aplicação para oferecer imóveis alugáveis em todo o estado de São Paulo',
                                  skills: 'Conhecimento em Rails, Web Design e segurança',
                                  date_limit: 20.days.from_now, work_regimen: :remote,
                                  hour_value: 300, user: @user, status: :open)

      @professional = Professional.create!(email: 'otavio@professional.com.br', password: 'ahudufgvya')
      @occupation_area = OccupationArea.create!(name: 'Dev')
      @profile = Profile.create!(birth_date: 18.years.ago, full_name: 'Otávio Lins',
                                 social_name: 'Otávio Augusto', prior_experience: 'Trabalhei como desenvolvedor em rails numa startup X',
                                 educational_background: 'Matemático', occupation_area: @occupation_area,
                                 description: 'Profissional em mud...', professional: @professional)

      login_as @professional, scope: :professional
      visit root_path
      fill_in 'Texto que deseja buscar', with: 'Cambalhota'
      click_on 'Buscar'

      expect(page).to have_content('Nenhum projeto com as palavras especificadas')
    end
  end
end
