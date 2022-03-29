class Chef < ApplicationRecord
  belongs_to :user
  has_many :courses
end
