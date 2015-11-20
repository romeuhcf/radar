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
    related?
  end

  def create?
    related?
  end

  def update?
    related?
  end

  def parse_preview?
    related?
  end

  protected
  def related?
    user.has_role?(:admin) or record.owner == user
  end
end
