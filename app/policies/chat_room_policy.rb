class ChatRoomPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      related?
    end
  end

  def archive?
    related?
  end

  def answer?
    related?
  end
end
