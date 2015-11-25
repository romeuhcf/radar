class TransmissionRequestCompositionServicePolicy < ApplicationPolicy
  def show?(step = nil)
    step ||= record.step
    related? && ['new', 'draft'].include?(record.transmission_request.status) && record.can_step_to?(step)
  end

  def update?
    related?
  end

  protected
  def related?
    (user.has_role?(:admin) or record.transmission_request.owner == user)
  end

end
