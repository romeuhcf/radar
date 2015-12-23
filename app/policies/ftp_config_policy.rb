class FtpConfigPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.has_role?(:admin)
        scope.all
      else
        scope.where(owner: user)
      end
    end
  end

  def update?
    related?
  end

  def edit?
    related?
  end

  def new?
    related?
  end

  def create?
    related?
  end

  def destroy?
    related?
  end

  def index?
    true
  end
end

