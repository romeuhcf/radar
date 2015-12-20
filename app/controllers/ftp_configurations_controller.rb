class FtpConfigurationsController < ApplicationController
  before_action :set_ftp_configuration, only: [:show, :edit, :update, :destroy]

  # GET /ftp_configurations
  def index
    @ftp_configurations = safe_scope.all
  end

  # GET /ftp_configurations/1
  def show
  end

  # GET /ftp_configurations/new
  def new
    @ftp_configuration = safe_scope.new
  end

  # GET /ftp_configurations/1/edit
  def edit
  end

  # POST /ftp_configurations
  def create
    @ftp_configuration = safe_scope.new(ftp_configuration_params)

    if @ftp_configuration.save
      redirect_to @ftp_configuration, notice: t('Ftp configuration was successfully created.')
    else
      render :new
    end
  end

  # PATCH/PUT /ftp_configurations/1
  def update
    if @ftp_configuration.update(ftp_configuration_params)
      redirect_to @ftp_configuration, notice: t('Ftp configuration was successfully updated.')
    else
      render :edit
    end
  end

  # DELETE /ftp_configurations/1
  def destroy
    @ftp_configuration.destroy
    redirect_to ftp_configurations_url, notice: 'Ftp configuration was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ftp_configuration
      @ftp_configuration = safe_scope.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def ftp_configuration_params
      params.require(:ftp_configuration).permit(:owner_id, :owner_type, :host, :port, :user, :secret, :passive, :kind).merge(owner: current_owner)
    end

    def safe_scope
      policy_scope(FtpConfiguration)
    end
end
class FtpConfigurationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.has_role?(:admin)
        scope.all
      else
        scope.where(owner: user)
      end
    end
  end

  def update?
    related?
  end

  def edit?
    related?
  end

  def new?
    related?
  end

  def create?
    related?
  end

  def destroy?
    related?
  end

  def index?
    true
  end
end

