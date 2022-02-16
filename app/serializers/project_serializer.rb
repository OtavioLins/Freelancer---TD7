class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :skills, :hour_value, :date_limit, :work_regimen
  belongs_to :user
  has_many :project_applications
end
