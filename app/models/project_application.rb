class ProjectApplication < ApplicationRecord
  belongs_to :project
  belongs_to :professional

  enum situation: {analysis: 0, accepted: 1, rejected: 2, canceled: 3}
  validates :motivation, :weekly_hours, :expected_conclusion, :expected_payment, presence: {message: 'é obrigatório(a)'}
  validates :weekly_hours, :expected_payment, numericality: {greater_than: 0, message: 'deve ser um número positivo'}
  validate :max_value
  validate :rejection
  validate :cancelation
  private

  def cancelation
    if (not self.acceptance_date.nil?) and Date.today <= (self.acceptance_date + 3)
      errors.add(:cancelation_message, 'é obrigatório(a)') if (self.canceled? and cancelation_message.blank?)
    end
  end

  def max_value
    if (not expected_payment.nil?) and Project.where(project_applications: self).first.hour_value < expected_payment
      errors.add(:expected_payment, 'não pode ser maior que o valor máximo por hora estipulado')
    end
  end

  def rejection
    errors.add(:reject_message, 'é obrigatório(a)') if (self.rejected? and reject_message.blank?)
  end
end