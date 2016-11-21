class HolidaysPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def index?
    user.user_policy?(false)
  end

  def new?
    user.user_policy?(false)
  end

  def edit?
    user.user_policy?(false)
  end

  def create?
    user.user_policy?(false)
  end

  def update?
    user.user_policy?(false)
  end

  def destroy?
    user.user_policy?(false)
  end
end
