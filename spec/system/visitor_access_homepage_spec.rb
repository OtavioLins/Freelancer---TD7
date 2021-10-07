require 'rails_helper'

describe 'Visitor access homepage' do
    it 'successfully' do
        visit root_path

        expect(page).to have_content('Freelancers')
        expect(page).to have_content('Boas vindas!')
    end
end