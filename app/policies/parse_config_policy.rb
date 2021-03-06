class ParseConfigPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(owner: user).named
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
