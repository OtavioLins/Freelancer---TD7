# frozen_string_literal: true

require 'rails_helper'

describe Profile do
  context 'Validation:' do
    it 'Creation - Presence' do
      project = Project.new
      project.valid?

      expect(project.errors.full_messages_for(:title)).to include(
        'Título é obrigatório(a)'
      )
      expect(project.errors.full_messages_for(:description)).to include(
        'Descrição é obrigatório(a)'
      )
      expect(project.errors.full_messages_for(:skills)).to include(
        'Habilidades buscadas é obrigatório(a)'
      )
      expect(project.errors.full_messages_for(:date_limit)).to include(
        'Data limite para propostas é obrigatório(a)'
      )
      expect(project.errors.full_messages_for(:hour_value)).to include(
        'Valor máximo por hora é obrigatório(a)'
      )
    end

    it 'Creation - date_limit cannot be in the past and hour_value must be a positive number' do
      project = Project.new(date_limit: 5.days.ago, hour_value: -750)
      project.valid?

      expect(project.errors.full_messages_for(:date_limit)).to include(
        'Data limite para propostas não pode ser no passado'
      )
      expect(project.errors.full_messages_for(:hour_value)).to include(
        'Valor máximo por hora deve ser um número positivo'
      )
    end
  end
end
