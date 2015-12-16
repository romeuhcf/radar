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
    related? && ['new', 'draft', 'scheduled'].include?(record.status)
  end

  def parse_preview?
    related?
  end

  def destroy?
    related? && [ 'new', 'draft', 'scheduled' ].include?(record.status)
  end

  def cancel?
    related? && ![ 'cancelled', 'finished' ].include?(record.status)
  end

  def pause?
    related? && record.processing?
  end

  def resume?
    related? && record.paused?
  end

end
