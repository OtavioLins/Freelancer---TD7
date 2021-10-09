class Profile < ApplicationRecord
  belongs_to :professional
  belongs_to :occupation_area
  validates :full_name, :social_name, :description, :educational_background,
  :prior_experience, :birth_date, :occupation_area_id, presence: {message: 'é obrigatório(a)'}
end
