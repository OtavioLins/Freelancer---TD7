require 'rails_helper'

describe 'Profile:' do
    context 'creation' do
        it 'immediately after sign up' do
            OccupationArea.create!(name: 'Dev')

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
            fill_in 'Data de nascimento', with: '08/19/1997'
            select 'Dev', from: 'Área de atuação'

            expect(page).to have_content('Perfil de Otávio')
            expect(page).to have_content('Nome: Otávio Augusto da Silva Lins')
            expect(page).to have_content('Formação: Matemático')
            expect(page).to have_content('Descrição: Profissional em mudança de carreira')
            expect(page).to have_content('Experiência prévia: Nenhuma')
            expect(page).to have_content('Data de nascimento: 19/08/1997')
            expect(page).to have_content('Área de atuação: Dev')
            expect(page).to have_content('Email: otavio@professional.com.br')
            expect(page).to have_link('Atualizar perfil')
        end
    end
end