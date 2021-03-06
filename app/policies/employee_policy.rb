class EmployeePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def index?
    user.user_policy?(false)
  end

  def show?
    user.user_policy?(true)
  end

  def new?
    user.user_policy?(false)
  end

  def edit?
    user.user_policy?(true)
  end

  def create?
    user.user_policy?(false)
  end

  def update?
    user.user_policy?(true)
  end

  def destroy?
    user.user_policy?(false)
  end

  def salaries?
    user.user_policy?(false)
  end
end
