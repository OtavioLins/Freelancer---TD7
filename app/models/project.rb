class Project < ApplicationRecord
  belongs_to :user
  has_many :project_applications
  enum work_regimen: {remote: 0, in_person: 1, hybrid: 2}
  enum status: {open: 0, closed: 1, finished: 2}
  validates :work_regimen, :title, :description, :skills, :date_limit, :hour_value,
  :user_id, presence: {message: 'é obrigatório(a)'}
  validates :hour_value, numericality: {greater_than_or_equal_to: 0, message: 'deve ser um número positivo'}

  validate :date_limit_cant_be_in_the_past, unless: :closed?

  private

  def date_limit_cant_be_in_the_past
    if (not date_limit.nil?) and (Time.now.to_date > date_limit)
        errors.add(:date_limit, 'não pode ser no passado')
    end
  end
end
