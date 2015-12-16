class MasqueradePolicy < ApplicationPolicy
  def show?
    admin?
  end
end
