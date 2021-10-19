class UserFeedback < ApplicationRecord

  belongs_to :professional
  belongs_to :project
  belongs_to :user

  validates :comment, :grade, presence: {message: 'é obrigatório(a)'}
  validates :grade, numericality: {only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5, message: 'deve ser um número inteiro entre 1 e 5'}

end
