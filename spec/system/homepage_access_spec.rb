# frozen_string_literal: true

require 'rails_helper'

describe 'Homepage access by' do
  context 'visitor:' do
    it 'successfully' do
      visit root_path

      expect(page).to have_content('Freelancers')
      expect(page).to have_content('Boas vindas!')
      expect(page).to have_link('Entrar como usuário')
      expect(page).to have_link('Entrar como profissional')
      expect(page).not_to have_content('Filtrar profissionais pela área de atuação')
      expect(page).not_to have_content('Buscar projetos a partir de palavras chave')
      expect(page).not_to have_content('Lista de projetos disponíveis')
      expect(page).not_to have_link('Buscar projetos')
      expect(page).not_to have_link('Cadastrar um novo projeto')
      expect(page).not_to have_link('Meu perfil')
      expect(page).not_to have_link('Meus projetos')
    end
  end

  context 'user:' do
    it 'successfully' do
      user = User.create!(email: 'otavio@user.com.br', password: '123123')

      login_as user, scope: :user
      visit root_path

      expect(page).to have_content(user.email)
      expect(page).to have_link('Cadastrar um novo projeto')
      expect(page).to have_link('Meus projetos')
      expect(page).to have_link('Sair')
      expect(page).to have_content('Freelancers')
      expect(page).to have_content('A seguir, temos uma lista de todos os profissionais disponíveis em nossa plataforma:')
      expect(page).not_to have_link('Meu perfil')
      expect(page).not_to have_content('Buscar projetos a partir de palavras chave')
      expect(page).not_to have_content('Lista de projetos disponíveis')
      expect(page).to have_content('Nenhum profissional cadastrado')
    end
  end

  context 'professional:' do
    it 'successfully' do
      @professional = Professional.create!(email: 'otavio@professional.com.br', password: 'ahudufgvya')
      @occupation_area = OccupationArea.create!(name: 'Dev')
      @profile = Profile.create!(birth_date: 18.years.ago, full_name: 'Otávio Lins',
                                 social_name: 'Otávio Augusto', prior_experience: 'Nenhuma',
                                 educational_background: 'Matemático', occupation_area: @occupation_area,
                                 description: 'Profissional em mud...', professional: @professional)

      login_as @professional, scope: :professional
      visit root_path

      expect(page).to have_content('Freelancers')
      expect(page).to have_content('Caro freelancer, boas vindas a nossa plataforma!')
      expect(page).to have_content('Filtrar projetos por uma palavra chave')
      expect(page).to have_content('A seguir, temos uma lista de todos os projetos disponíveis em nossa plataforma:')
      expect(page).to have_content('Nenhum projeto aberto')
      expect(page).to have_link('Meu perfil')
      expect(page).to have_link('Meus projetos')
      expect(page).to have_link('Sair')
      expect(page).not_to have_link('Cadastrar um novo projeto')
    end

    it 'gets redirected to profile creation page' do
      @professional = Professional.create!(email: 'otavio@professional.com.br', password: 'ahudufgvya')

      login_as @professional, scope: :professional
      visit root_path

      expect(page).to have_content('Crie seu perfil')
    end
  end
end
