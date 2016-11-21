class DrivePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def index?
    user.user_policy?(false)
  end

  def update?
    user.user_policy?(false)
  end
end
