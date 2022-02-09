# frozen_string_literal: true

require 'rails_helper'

describe ProjectApplication do
  context 'Validation:' do
    it 'Creation - Presence' do
      project_application = ProjectApplication.new
      project_application.valid?

      expect(project_application.errors.full_messages_for(:motivation)).to include(
        'Porque se acha capaz de pegar esse projeto? é obrigatório(a)'
      )
      expect(project_application.errors.full_messages_for(:weekly_hours)).to include(
        'Horas semanais que pretende trabalhar no projeto é obrigatório(a)'
      )
      expect(project_application.errors.full_messages_for(:expected_conclusion)).to include(
        'Expectativa de conclusão é obrigatório(a)'
      )
      expect(project_application.errors.full_messages_for(:expected_payment)).to include(
        'Valor que espera receber por hora é obrigatório(a)'
      )
    end
    it 'Creation - expected_payment and weekly_hours must be numbers' do
      project_application = ProjectApplication.new(motivation: 'Trabalhei em ...', expected_conclusion: '1 mês',
                                                   weekly_hours: -10, expected_payment: 'sjfhdBIAGML',
                                                   project: create(:project), situation: :analysis,
                                                   professional: create(:professional, complete_profile: true))
      project_application.valid?

      expect(project_application.errors.full_messages_for(:weekly_hours)).to include(
        'Horas semanais que pretende trabalhar no projeto deve ser um número positivo'
      )
      expect(project_application.errors.full_messages_for(:expected_payment)).to include(
        'Valor que espera receber por hora deve ser um número positivo'
      )
    end

    it 'Creation - expected_payment cannot excede a certain value' do
      project_application = ProjectApplication.new(motivation: 'Trabalhei em ...', expected_conclusion: '1 mês',
                                                   weekly_hours: 10, expected_payment: 550,
                                                   project: create(:project, hour_value: 200),
                                                   professional: create(:professional, complete_profile: true),
                                                   situation: :analysis)

      project_application.valid?

      expect(project_application.errors.full_messages_for(:expected_payment)).to include(
        'Valor que espera receber por hora não pode ser maior que o valor máximo por hora estipulado'
      )
    end
  end
end
