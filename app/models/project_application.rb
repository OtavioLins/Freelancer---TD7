class ProjectApplication < ApplicationRecord
  belongs_to :project
  belongs_to :professional

  enum status: {analysis: 0, accepted: 1, rejected: 2}

end
