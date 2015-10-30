class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :set_mailer_host

  private

  def set_mailer_host
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end

end
