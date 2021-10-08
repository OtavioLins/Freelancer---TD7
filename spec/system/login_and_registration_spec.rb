require 'rails_helper'

describe 'login and registration:' do
    context 'User' do
        it 'logs in successfully' do
            user = User.create!(email: 'otavio@user.com.br', password: '123456789')
        
            visit root_path
            click_on 'Entrar como usuário'
            fill_in 'Email', with: user.email
            fill_in 'Senha', with: user.password
            click_on 'Entrar'

            expect(page).to have_content(user.email)
            expect(page).to have_content('Login efetuado com sucesso')
            expect(page).to have_link('Meus projetos')
            expect(page).to have_link('Cadastrar um novo projeto')
            expect(page).not_to have_link('Entrar como usuário')
            expect(page).not_to have_link('Entrar como profissional')
            expect(page).to have_link('Sair')
        end

        it 'logs in using unregistered email' do
            visit root_path
            click_on 'Entrar como usuário'
            fill_in 'Email', with: 'otavio@user.com.br'
            click_on 'Entrar'

            expect(page).to have_content('Email ou senha inválida')
        end

        it 'register successfully' do
            visit root_path
            click_on 'Entrar como usuário'
            click_on 'Se cadastre aqui'
            fill_in 'Email', with: 'otavio@user.com.br'
            fill_in 'Senha', with: '123456789'
            fill_in 'Confirme sua senha', with: '123456789'
            click_on 'Cadastrar'

            expect(page).to have_content('otavio@user.com.br')
            expect(page).to have_content('Login efetuado com sucesso')
            expect(page).to have_link('Meus projetos')
            expect(page).to have_link('Cadastrar um novo projeto')
            expect(page).not_to have_link('Entrar como usuário')
            expect(page).not_to have_link('Entrar como profissional')
            expect(page).to have_link('Sair')
            expect(User.count).to eq(1)
        end

        it 'tries to register using an already registered email' do
        
        User.create!(email: 'otavio@user.com.br', password: '123456789')

        visit root_path
        click_on 'Entrar como usuário'
        click_on 'Se cadastre aqui'
        fill_in 'Email', with: 'otavio@user.com.br'
        fill_in 'Senha', with: '123456789'
        fill_in 'Confirme sua senha', with: '123456789'
        click_on 'Cadastrar'

        expect(page).to have_content('Email já está em uso')
        expect(User.count).to eq(1)
        end

        it 'tries to register but doesnt confirm password correctly' do
            visit root_path
            click_on 'Entrar como usuário'
            click_on 'Se cadastre aqui'
            fill_in 'Email', with: 'otavio@user.com.br'
            fill_in 'Senha', with: '123456789'
            fill_in 'Confirme sua senha', with: '159478963'
            click_on 'Cadastrar'
    
            expect(page).to have_content('Confirme sua senha não é igual a Senha')
            expect(User.count).to eq(0)
        end

        it 'logs out' do
            user = User.create!(email: 'otavio@user.com.br', password: '123456789')

            login_as user, scope: :user
            visit root_path
            click_on 'Sair'

            expect(page).to have_content('Saiu com sucesso.')
            expect(page).to have_link('Entrar como usuário')
            expect(page).to have_link('Entrar como profissional')
        end
    end

    context 'Professional' do
        it 'logs in successfully' do
            professional = Professional.create!(email: 'otavio@professional.com.br', password: '123456789')
            
            visit root_path
            click_on 'Entrar como profissional'
            fill_in 'Email', with: professional.email
            fill_in 'Senha', with: professional.password
            click_on 'Entrar'
    
            expect(page).to have_content(professional.email)
            expect(page).to have_content('Login efetuado com sucesso')
            expect(page).to have_link('Meu perfil')
            expect(page).to have_link('Buscar projetos')
            expect(page).not_to have_link('Entrar como usuário')
            expect(page).not_to have_link('Entrar como profissional')
            expect(page).to have_link('Sair')
        end

        it 'logs in using unregistered email' do
 
            visit root_path
            click_on 'Entrar como profissional'
            fill_in 'Email', with: 'otavio@professional.com.br'
            click_on 'Entrar'

            expect(page).to have_content('Email ou senha inválida')
        end

        it 'register successfully' do
            visit root_path
            click_on 'Entrar como profissional'
            click_on 'Se cadastre aqui'
            fill_in 'Email', with: 'otavio@professional.com.br'
            fill_in 'Senha', with: '123456789'
            fill_in 'Confirme sua senha', with: '123456789'
            click_on 'Cadastrar'

            expect(page).to have_content('otavio@professional.com.br')
            expect(page).to have_content('Crie seu perfil')
            expect(page).to have_link('Meu perfil')
            expect(page).to have_link('Buscar projetos')
            expect(page).to have_link('Sair')
            expect(page).not_to have_link('Entrar como usuário')
            expect(page).not_to have_link('Entrar como profissional')
            expect(Professional.count).to eq(1)
        end

        it 'tries to register but doesnt confirm password' do
            visit root_path
            click_on 'Entrar como profissional'
            click_on 'Se cadastre aqui'
            fill_in 'Email', with: 'otavio@professional.com.br'
            fill_in 'Senha', with: '123456789'
            fill_in 'Confirme sua senha', with: '159478963'
            click_on 'Cadastrar'
    
            expect(page).to have_content('Confirme sua senha não é igual a Senha')
            expect(User.count).to eq(0)
        end

        it 'tries to register using an already registered email' do
        
            Professional.create!(email: 'otavio@professional.com.br', password: '123456789')

            visit root_path
            click_on 'Entrar como profissional'
            click_on 'Se cadastre aqui'
            fill_in 'Email', with: 'otavio@professional.com.br'
            fill_in 'Senha', with: '123456789'
            fill_in 'Confirme sua senha', with: '123456789'
            click_on 'Cadastrar'
    
            expect(page).to have_content('Email já está em uso')
            expect(Professional.count).to eq(1)
        end

        it 'logs out' do
            professional = Professional.create!(email: 'otavio@professional.com.br', password: '123456789')

            login_as professional, scope: :professional
            visit root_path
            click_on 'Sair'

            expect(page).to have_content('Saiu com sucesso.')
            expect(page).to have_link('Entrar como usuário')
            expect(page).to have_link('Entrar como profissional')
        end
    end
end
