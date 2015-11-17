class TransmissionRequestPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.has_role?(:admin)
        scope.all
      else
        scope.where(owner: user)
      end
    end
  end

  def new?
    true
  end

  def create?
    true
  end

  def update?
    true
  end
end
