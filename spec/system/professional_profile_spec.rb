require 'rails_helper'
describe 'Profile:' do
  context 'creation' do
    it 'immediately after sign up' do
      create(:occupation_area, name: 'Dev')

      visit root_path
      click_on 'Entrar como profissional'
      click_on 'Se cadastre aqui'
      fill_in 'Email', with: 'otavio@professional.com.br'
      fill_in 'Senha', with: '123456789'
      fill_in 'Confirme sua senha', with: '123456789'
      click_on 'Cadastrar'
      fill_in 'Nome completo', with: 'Otávio Augusto da Silva Lins'
      fill_in 'Nome social', with: 'Otávio Augusto da Silva Lins'
      fill_in 'Formação', with: 'Matemático'
      fill_in 'Descrição', with: 'Profissional em mudança de carreira'
      fill_in 'Experiência prévia', with: 'Nenhuma'
      fill_in 'Data de nascimento', with: '19/08/1997'
      select 'Dev', from: 'Área de atuação'
      click_on 'Criar perfil'

      expect(Profile.count).to eq(1)
      expect(page).to have_content('Perfil de Otávio')
      expect(page).to have_content('Profissional em mudança de carreira')
      expect(page).to have_content('Nome: Otávio Augusto da Silva Lins')
      expect(page).to have_content('Formação: Matemático')
      expect(page).to have_content('Experiência prévia: Nenhuma')
      expect(page).to have_content('Data de nascimento: 19/08/1997')
      expect(page).to have_content('Área de atuação: Dev')
      expect(page).to have_content('Email: otavio@professional.com.br')
      expect(page).to have_link('Atualizar perfil')
    end
        
    it 'after login in without a valid profile' do
      @professional = create(:professional)

      visit root_path
      click_on 'Entrar como profissional'
      fill_in 'Email', with: @professional.email
      fill_in 'Senha', with: @professional.password
      click_on 'Entrar'

      expect(page).to have_content('Crie seu perfil')
    end
        
    it 'after clicking on Meu perfil without a valid profile' do
      @professional = create(:professional)

      login_as @professional, scope: :professional
      visit root_path
      click_on 'Meu perfil'

      expect(page).to have_content('Crie seu perfil')
    end

    it 'unssucessfully - professional left some attributes blank' do
      @professional = create(:professional)

      login_as @professional, scope: :professional
      visit root_path
      click_on 'Meu perfil'
      click_on 'Criar perfil'

      expect(page).to have_content('Crie seu perfil')
      expect(page).to have_content('Nome completo é obrigatório(a)')
      expect(page).to have_content('Nome social é obrigatório(a)')
      expect(page).to have_content('Descrição é obrigatório(a)')
      expect(page).to have_content('Experiência prévia é obrigatório(a)')
      expect(page).to have_content('Data de nascimento é obrigatório(a)')
      expect(page).to have_content('Formação é obrigatório(a)')
      expect(page).to have_content('Área de atuação é obrigatório(a)')
    end
  end

  context 'Edit:' do
    it 'successfully' do
      @professional = create(:professional)
      @occupation_area = create(:occupation_area, name: 'Dev')
      @profile = create(:profile, birth_date: 18.years.ago, full_name: 'Otávio Lins', 
                        social_name: 'Otávio Augusto', prior_experience: 'Nenhuma',
                        occupation_area: @occupation_area, professional: @professional)

      login_as @professional, scope: :professional
      visit root_path
      click_on 'Meu perfil'
      click_on 'Atualizar perfil'
      fill_in 'Nome completo', with: 'Otávio Augusto da Silva Lins'
      fill_in 'Experiência prévia', with: 'Trabalhei na level up como designer de jogos'
      click_on 'Atualizar perfil'

      expect(page).to have_content('Perfil de Otávio')
      expect(page).to have_content('Nome: Otávio Augusto')
      expect(page).to have_content('Experiência prévia: Trabalhei na level up como designer de jogos')
      expect(page).to have_content('Área de atuação: Dev')
      expect(page).to have_link('Atualizar perfil')
    end

    it 'Unsuccessful' do
      @professional = create(:professional)
      @profile = create(:profile, occupation_area: create(:occupation_area),
                        professional: @professional)

      login_as @professional, scope: :professional
      visit root_path
      click_on 'Meu perfil'
      click_on 'Atualizar perfil'
      fill_in 'Nome completo', with: 'Otávio'
      fill_in 'Descrição', with: ''
      fill_in 'Experiência prévia', with: 'Trabalhei na level up como designer de jogos'
      fill_in 'Data de nascimento', with: 17.years.ago
      click_on 'Atualizar perfil'

      expect(page).to have_content('Data de nascimento : Profissional deve ser maior de 18 anos')
      expect(page).to have_content('Nome completo deve incluir um sobrenome')
      expect(page).not_to have_content('Nome social é obrigatório(a)')
      expect(page).to have_content('Descrição é obrigatório(a)')
    end
  end

  context 'Visualization:' do
    it 'through Meu perfil' do
      @professional = Professional.create!(email: 'otavio@professional.com.br', password: 'ahudufgvya')
      @occupation_area = OccupationArea.create!(name: 'Dev')
      @profile = Profile.create!(birth_date: 18.years.ago, full_name: 'Otávio Lins', 
                                  social_name: 'Otávio Augusto', prior_experience: 'Nenhuma',
                                  educational_background: 'Matemático', occupation_area: @occupation_area,
                                  description: 'Profissional em mud...', professional: @professional)
      
      login_as @professional, scope: :professional
      visit root_path 
      click_on 'Meu perfil'

      expect(page).to have_content('Perfil de Otávio')
      expect(page).to have_content('Profissional em mud...')
      expect(page).to have_content('Nome: Otávio Augusto')
      expect(page).to have_content('Formação: Matemático')
      expect(page).to have_content('Experiência prévia: Nenhuma')
      expect(page).to have_content('Área de atuação: Dev')
      expect(page).to have_content('Email: otavio@professional.com.br')
      expect(page).to have_link('Atualizar perfil')
    end
    
    it 'through User homepage' do
      user = User.create!(email: 'otavio@user.com.br', password: '123456789')
      @professional = Professional.create!(email: 'otavio@professional.com.br', password: 'ahudufgvya')
      @occupation_area = OccupationArea.create!(name: 'Dev')
      @profile = Profile.create!(birth_date: 18.years.ago, full_name: 'Otávio Lins', 
                                  social_name: 'Otávio Augusto', prior_experience: 'Nenhuma',
                                  educational_background: 'Matemático', occupation_area: @occupation_area,
                                  description: 'Profissional em mud...', professional: @professional)
      
      login_as user, scope: :user
      visit root_path
      click_on @profile.social_name

      expect(page).to have_content('Perfil de Otávio')
      expect(page).to have_content('Profissional em mud...')
      expect(page).to have_content('Nome: Otávio Augusto')
      expect(page).to have_content('Formação: Matemático')
      expect(page).to have_content('Experiência prévia: Nenhuma')
      expect(page).to have_content('Área de atuação: Dev')
      expect(page).to have_content('Email: otavio@professional.com.br')
      expect(page).not_to have_link('Atualizar perfil')
    end
  end
end