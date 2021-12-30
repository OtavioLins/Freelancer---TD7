# frozen_string_literal: true

class Professional < ApplicationRecord
  has_one :profile
  has_many :project_applications
  has_many :projects, through: :project_applications
  has_many :user_feedbacks

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def average_grade
    return 'Esse profissional ainda não recebeu nenhum feedback' if user_feedbacks.count.zero?

    average = 0
    user_feedbacks.each do |feedback|
      average += feedback.grade
    end
    average / user_feedbacks.count
  end

  def finished_and_accepted_projects
    projects = []
    self.projects.each do |l|
      application = l.project_applications.find_by(professional: self)
      projects << l if l.finished? && application.accepted?
    end
    return 'Esse profissional ainda não atuou em nenhum projeto' if projects.blank?

    projects
  end
end
