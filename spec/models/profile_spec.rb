require 'rails_helper'

describe Profile do
    context 'Validation:' do
        it 'Creation - Presence' do
            @profile = Profile.new
            @profile.valid?

            expect(@profile.errors.full_messages_for(:full_name)).to include(
            'Nome completo é obrigatório(a)')
            expect(@profile.errors.full_messages_for(:social_name)).to include(
            'Nome social é obrigatório(a)')
            expect(@profile.errors.full_messages_for(:description)).to include(
            'Descrição é obrigatório(a)')
            expect(@profile.errors.full_messages_for(:occupation_area)).to include(
            'Área de atuação é obrigatório(a)')
            expect(@profile.errors.full_messages_for(:educational_background)).to include(
            'Formação é obrigatório(a)')
            expect(@profile.errors.full_messages_for(:birth_date)).to include(
            'Data de nascimento é obrigatório(a)')
            expect(@profile.errors.full_messages_for(:prior_experience)).to include(
            'Experiência prévia é obrigatório(a)')
        end

        it 'Creation - Professional must be over 18 years old 1' do
            @professional = Professional.create!(email: 'otavio@gmail.com', password: 'ahudufgvya')
            @occupation_area = OccupationArea.create!(name: 'Dev')
            @profile = Profile.new(birth_date: 17.years.ago, full_name: 'Otávio Augusto', 
                                   social_name: 'Otávio Augusto', prior_experience: 'Nenhuma',
                                   educational_background: 'Matemático', occupation_area: @occupation_area,
                                   description: 'Profissional em mud...', professional: @professional)
            
            expect(@profile.valid?).to eq(false)
            expect(@profile.errors.full_messages_for(:birth_date)).to include(
            'Data de nascimento : Profissional deve ser maior de 18 anos')
        end

        it 'Creation - Professional must have a name and a surname' do
            @professional = Professional.create!(email: 'otavio@gmail.com', password: 'ahudufgvya')
            @occupation_area = OccupationArea.create!(name: 'Dev')
            @profile = Profile.new(birth_date: 18.years.ago, full_name: 'Otávio', 
                                   social_name: 'Otávio Augusto', prior_experience: 'Nenhuma',
                                   educational_background: 'Matemático', occupation_area: @occupation_area,
                                   description: 'Profissional em mud...', professional: @professional)
            
            expect(@profile.valid?).to eq(false)
            expect(@profile.errors.full_messages_for(:birth_date)).not_to include(
            'Data de nascimento : Profissional deve ser maior de 18 anos')
            expect(@profile.errors.full_messages_for(:full_name)).to include(
            'Nome completo deve incluir um sobrenome')
        end
        
        it 'Update - Professional tries to change some attributes to blank/nil/invalid' do
            @professional = Professional.create!(email: 'otavio@gmail.com', password: 'ahudufgvya')
            @occupation_area = OccupationArea.create!(name: 'Dev')
            @profile = Profile.create!(birth_date: 18.years.ago, full_name: 'Otávio Lins', 
                                       social_name: 'Otávio Augusto', prior_experience: 'Nenhuma',
                                       educational_background: 'Matemático', occupation_area: @occupation_area,
                                       description: 'Profissional em mud...', professional: @professional)
            @profile.update(birth_date: 17.years.ago, full_name: 'Otávio', educational_background: '')
            expect(@profile.valid?).to eq(false)
            expect(@profile.errors.full_messages_for(:birth_date)).to include(
            'Data de nascimento : Profissional deve ser maior de 18 anos')
            expect(@profile.errors.full_messages_for(:full_name)).to include(
            'Nome completo deve incluir um sobrenome')
            expect(@profile.errors.full_messages_for(:educational_background)).to include(
            'Formação é obrigatório(a)')
            expect(@profile.errors.full_messages_for(:social_name)).not_to include(
            'Nome social é obrigatório(a)')
        end
    end 
end
