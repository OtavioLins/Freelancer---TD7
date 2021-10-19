class Profile < ApplicationRecord

  belongs_to :professional
  belongs_to :occupation_area

  validates :full_name, :social_name, :description, :educational_background,
  :prior_experience, :birth_date, :occupation_area_id, presence: {message: 'é obrigatório(a)'}

  validate :must_be_over_18_years_old, :must_include_a_surname

  private

  def must_be_over_18_years_old
    if birth_date and 18.years.ago < birth_date
        errors.add(:birth_date, ': Profissional deve ser maior de 18 anos')
    end
  end

  def must_include_a_surname
    if full_name and full_name.split.length < 2
      errors.add(:full_name, 'deve incluir um sobrenome')
    end
  end
end
