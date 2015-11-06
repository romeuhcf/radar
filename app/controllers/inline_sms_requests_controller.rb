class InlineSmsRequestsController < ApplicationController

  before_action :authenticate_user!

  def new
    @inline_sms_request = InlineSmsRequest.new
  end

  def create
    @inline_sms_request = InlineSmsRequest.new(inline_params)
    @inline_sms_request.user = current_user

    @transmission_request = @inline_sms_request.save
    if @transmission_request
      redirect_to root_path, notice: "Mensagens enviadas com sucesso: #{@transmission_request.messages.count}."
    else
      render :new
    end
  end

  private
  def inline_params
    params.required(:inline_sms_request).permit(:phone_numbers, :message)
  end
end
