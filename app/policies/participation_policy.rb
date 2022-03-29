class ParticipationPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
  def create?
    !record.course.in? user.courses_as_participant
  end

  def past_participations?
    true
  end

  def upcoming_participations?
    true
  end

  def favorites?
    true
  end

  def add_in_favorite?
    true
  end
end
