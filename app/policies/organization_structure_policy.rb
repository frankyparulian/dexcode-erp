class OrganizationStructurePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end
  def index?
    user.user_policy?(false)
  end

  def datafilter?
    user.user_policy?(false)
  end

  def update_parent?
    user.user_policy?(false)
  end
  
  def destroy?
    user.user_policy?(false)
  end
end
