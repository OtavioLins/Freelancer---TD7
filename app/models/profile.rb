class Profile < ApplicationRecord
  belongs_to :professional
  belongs_to :occupation_area
end
