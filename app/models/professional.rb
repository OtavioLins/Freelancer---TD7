class Professional < ApplicationRecord
  has_one :profile
  has_many :project_applications
  has_many :projects, through: :project_applications
  has_many :user_feedbacks
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
