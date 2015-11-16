class InlineSmsRequestPolicy < ApplicationPolicy
  def create?
    true # TODO verificar se tem creditos e se é usuario com papel de enviador
  end
end
