class TransmissionRequestCompositionServicePolicy < ApplicationPolicy
  def show?(step = nil)
    step ||= record.step
    related? && ['new', 'draft', 'scheduled'].include?(record.transmission_request.status) && record.can_step_to?(step)
  end

  def update?
    related? && ['new', 'draft', 'scheduled'].include?(record.transmission_request.status)
  end

  def cancel?
    true
  end

  protected
  def related?
    admin? or (record.transmission_request.owner == user)
  end

end
