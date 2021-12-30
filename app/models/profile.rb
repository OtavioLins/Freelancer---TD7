# frozen_string_literal: true

class Profile < ApplicationRecord
  belongs_to :professional
  belongs_to :occupation_area

  validates :full_name, :social_name, :description, :educational_background,
            :prior_experience, :birth_date, :occupation_area_id, presence: { message: 'é obrigatório(a)' }

  validate :must_be_over_18_years_old, :must_include_a_surname

  private

  def must_be_over_18_years_old
    errors.add(:birth_date, ': Profissional deve ser maior de 18 anos') if birth_date && (18.years.ago < birth_date)
  end

  def must_include_a_surname
    errors.add(:full_name, 'deve incluir um sobrenome') if full_name && (full_name.split.length < 2)
  end
end
