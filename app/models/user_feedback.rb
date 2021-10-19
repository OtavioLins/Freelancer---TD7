class UserFeedback < ApplicationRecord

  belongs_to :professional
  belongs_to :project
  belongs_to :user

end
