class Users::MasqueradesController < Devise::MasqueradesController
  before_action :authenticate_user!

  def show
    authorize :masquerade, :show?
    super
  end

  def back
    super
  end
end
