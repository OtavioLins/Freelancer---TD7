require 'rails_helper'

describe 'Users projects' do
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
            # expect(page).to have_content('Data limite para propostas: #{data}')
            #TODO learn how to configure the data for the test
            expect(page).to have_content('Regime de trabalho: remoto')
        end

        it "Unsuccessfully - Left everything blank" do
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
        it 'through Meus projetos' do
        end

        it 'though Professional homepage' do
        end
    end
end