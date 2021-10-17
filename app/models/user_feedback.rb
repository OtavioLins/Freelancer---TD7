class UserFeedback < ApplicationRecord
  belongs_to :professional
  belongs_to :project
end
