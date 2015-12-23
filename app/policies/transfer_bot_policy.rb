class TransferBotPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.has_role?(:admin)
        scope.all
      else
        scope.where(owner: user)
      end
    end
  end

  def show?
    related?
  end

  def update?
    related?
  end

  def deactivate?
    related? && record.enabled?
  end

  def activate?
    related? && !record.enabled?
  end


end
