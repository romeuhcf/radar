class FileDownloadRulePolicy < ApplicationPolicy
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
  def pause?
    related? && record.enabled?
  end

  def resume?
    related? && !record.enabled?
  end


end
