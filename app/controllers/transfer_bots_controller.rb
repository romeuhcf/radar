class TransferBotsController < ApplicationController
  before_action :set_transfer_bot, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized, unless: [:index]
  before_action :authenticate_user!

  # GET /transfer_bots
  # GET /transfer_bots.json
  def index
    smart_listing_create :transfer_bots,
      safe_scope,
      partial: "transfer_bots/list",
      default_sort: {created_at: "desc"}
  end

  # GET /transfer_bots/1
  # GET /transfer_bots/1.json
  def show
  end

  # GET /transfer_bots/new
  def new
    @transfer_bot = safe_scope.new
  end

  # GET /transfer_bots/1/edit
  def edit
  end

  # POST /transfer_bots
  # POST /transfer_bots.json
  def create
    @transfer_bot = safe_scope.new(transfer_bot_params)

    respond_to do |format|
      if @transfer_bot.save
        format.html { redirect_to @transfer_bot, notice: t("transfer_bot.notify.success.create") }
        format.json { render :show, status: :created, location: @transfer_bot }
      else
        format.html { render :new }
        format.json { render json: @transfer_bot.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transfer_bots/1
  # PATCH/PUT /transfer_bots/1.json
  def update
    respond_to do |format|
      if @transfer_bot.update(transfer_bot_params)
        format.html { redirect_to @transfer_bot, notice: t("transfer_bot.notify.success.update") }
        format.json { render :show, status: :ok, location: @transfer_bot }
      else
        format.html { render :edit }
        format.json { render json: @transfer_bot.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transfer_bots/1
  # DELETE /transfer_bots/1.json
  def destroy
    @transfer_bot.destroy
    respond_to do |format|
      format.html { redirect_to transfer_bots_url, notice: t("transfer_bot.notify.success.destroy") }
      format.json { head :no_content }
    end
  end

  def activate
    @transfer_bot = safe_scope.find(params[:id])
    authorize @transfer_bot
    @transfer_bot.activate!
    redirect_to @transfer_bot, notice: t("transfer_bot.notify.success.activate")
  end

  def deactivate
    @transfer_bot = safe_scope.find(params[:id])
    authorize @transfer_bot
    @transfer_bot.deactivate!
    redirect_to @transfer_bot, notice: t("transfer_bot.notify.success.deactivate")
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_transfer_bot
    @transfer_bot = safe_scope.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def transfer_bot_params
    params.require(:transfer_bot).permit(:worker_class, :description, :enabled, :schedule, :remote_path, :patterns, :source_delete_after, ftp_config_attributes: [:host, :port, :user, :secret, :passive, :id] ).merge(owner: current_owner, worker_class: 'FileDownloadWorker')
  end

  def safe_scope
    policy_scope(TransferBot)
  end
end
