class ChatRoomPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.has_role?(:admin)
        scope.all
      else
        scope.where(owner: user)
      end
    end
  end

  def archive?
    true # TODO check role
  end

  def answer?
    true # TODO check credit permission
  end
end
