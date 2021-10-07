require 'rails_helper'

describe 'Visitor access homepage' do
    it 'successfully' do
        visit root_path

        expect(page).to have_content('Freelancers')
        expect(page).to have_content('Boas vindas!')
        expect(page).to have_link('Entrar como usuário')
        expect(page).to have_link('Entrar como profissional')
    end
end