class OccupationArea < ApplicationRecord
    has_many :profiles
    validates :name, presence: true
    validates :name, uniqueness: true
end
