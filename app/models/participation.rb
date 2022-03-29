class Participation < ApplicationRecord
  belongs_to :user
  belongs_to :course

  scope :past, -> { joins(:course).where("courses.start_at < ?", Time.now) }
  scope :upcoming, -> { joins(:course).where("courses.start_at > ?", Time.now) }
  scope :favorites, -> { where("favorite > ?", true) }
end
