class ChatRoomPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(owner: user)
    end
  end

  def archive?
    related?
  end

  def answer?
    related?
  end
end
