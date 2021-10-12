class Professional < ApplicationRecord
  has_one :profile
  has_many :project_applications
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
