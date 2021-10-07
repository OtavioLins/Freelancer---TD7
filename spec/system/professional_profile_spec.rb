require 'rails_helper'

describe 'Profile:' do
    context 'creation' do
        it 'done successfully' do
            
            professional = Professional.create!(email: 'otavio@professional.com.br', password: '123456789')
            OccupationArea.create!(name: 'Dev')
            login_as professional, scope: :professional
            visit root_path
            click_on 'Meu perfil'
            
            fill_in 'Nome completo', with: 'Otávio Augusto da Silva Lins'
            fill_in 'Nome social', with: 'Otávio Augusto da Silva Lins'
            fill_in 'Formação', with: 'Matemático'
            fill_in 'Descrição', with: 'Profissional em mudança de carreira'
            fill_in 'Experiência prévia', with: 'Nenhuma'
            fill_in 'Data de nascimento', with: '19/08/1997'
            select 'Dev', from: 'Área de atuação'

            expect(page).to have_content('Meu perfil')
            expect(page).to have_content('Otávio Augusto da Silva Lins')
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