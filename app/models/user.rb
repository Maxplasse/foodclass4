class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :chef
  has_many :courses, through: :chef
  has_many :participations, dependent: :destroy
  has_many :emojis, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :courses_as_participant, through: :participations, source: :course
  has_many :invitations, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  include PgSearch::Model
  multisearchable against: [:first_name, :last_name, :nickname]

  def number_of_points
    courses_as_participant.sum(:level_points)
  end

  LEVELS = [
    {
      min_points: 0,
      max_points: 49,
      name: "Apprenti",
      icon_level_unlocked: "Apprenti-unlocked.png",
      icon_level_locked: "Apprenti-locked.png",
      badge: "Apprenti.svg"
    },
    {
      min_points: 50,
      max_points: 124,
      name: "Commis",
      icon_level_unlocked: "Commis-unlocked.png",
      icon_level_locked: "Commis-locked.png",
      badge: "Commis.svg"
    },
    {
      min_points: 125,
      max_points: 249,
      name: "Sous-chef",
      icon_level_unlocked: "Souschef-unlocked.png",
      icon_level_locked: "Souschef-locked.png",
      badge: "Souschef.svg"
    },
    {
      min_points: 250,
      max_points: 399,
      name: "Chef",
      icon_level_unlocked: "Chef-unlocked.png",
      icon_level_locked: "Chef-locked.png",
      badge: "Chef.svg"
    },
    {
      min_points: 400,
      max_points: 1_000_000,
      name: "FoodClass Chef",
      icon_level_unlocked: "FoodClassChef-unlocked.png",
      icon_level_locked: "FoodclassChef-locked.png",
      badge: "Foodclass_chef.svg"
    }
  ]

  def current_level
    LEVELS.find do |level|
      number_of_points >= level[:min_points] && number_of_points <= level[:max_points]
    end
  end

  def current_level_name
    current_level[:name]
  end

  def current_level_icon_unlocked
    current_level[:icon_level_unlocked]
  end

  def current_level_icon_locked
    current_level[:icon_level_locked]
  end

  def current_level_badge
    current_level[:badge]
  end

  def level_validated?(level)
    LEVELS.index(level) <= LEVELS.index(current_level)
  end

  def next_level_min_points
    (current_level[:max_points] + 1) - number_of_points
  end

  def next_level_name
    LEVELS[LEVELS.index(current_level) + 1][:name]
  end
end
