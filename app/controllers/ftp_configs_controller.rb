class FtpConfigsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_ftp_config, only: [:show, :edit, :update, :destroy]

  # GET /ftp_configs
  def index
    @ftp_configs = safe_scope.all
  end

  # GET /ftp_configs/1
  def show
  end

  # GET /ftp_configs/new
  def new
    @ftp_config = safe_scope.new
  end

  # GET /ftp_configs/1/edit
  def edit
  end

  # POST /ftp_configs
  def create
    @ftp_config = safe_scope.new(ftp_config_params)

    if @ftp_config.save
      redirect_to @ftp_config, notice: t('ftp_config.notify.success.create')
    else
      render :new
    end
  end

  # PATCH/PUT /ftp_configs/1
  def update
    if @ftp_config.update(ftp_config_params)
      redirect_to @ftp_config, notice: t('ftp_config.notify.success.update')
    else
      render :edit
    end
  end

  # DELETE /ftp_configs/1
  def destroy
    @ftp_config.destroy
    redirect_to ftp_configs_url, notice: t('ftp_config.notify.success.destroy')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ftp_config
      @ftp_config = safe_scope.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def ftp_config_params
      params.require(:ftp_config).permit(:owner_id, :owner_type, :host, :port, :user, :secret, :passive, :kind).merge(owner: current_owner)
    end

    def safe_scope
      policy_scope(FtpConfig)
    end
end

