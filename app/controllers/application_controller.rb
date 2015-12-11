#
class ApplicationController < ActionController::Base
  include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper
  include Pundit

  after_action :notify_client_action

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected
  def after_sign_in_path_for(resource)
    dashboard_index_path
  end

  def current_owner
    current_user # TODO teams
  end

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore

    flash[:error] = t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default
    redirect_to(request.referrer || authenticated_root_path)
  end

  def notify_client_action
    return if request.request_method == 'GET'
    CustomerMonitoringService.delay.notify(request.path, current_user && current_user.id, params)
  end
end
