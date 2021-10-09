require 'rails_helper'

describe Profile do
    context 'Validation:' do
        it 'Presence' do
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

        it 'Birth date must be valid' do
        
        end

        it 'Must have a name and a surname' do
        
        end
    end 
end
