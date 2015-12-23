class ScheduleSpanConfigsController < ApplicationController
  before_action :set_schedule_span_config, only: [:show, :edit, :update, :destroy]

  # GET /schedule_span_configs
  def index
    @schedule_span_configs = safe_scope.all
  end

  # GET /schedule_span_configs/1
  def show
  end

  # GET /schedule_span_configs/new
  def new
    @schedule_span_config = safe_scope.new
  end

  # GET /schedule_span_configs/1/edit
  def edit
  end

  # POST /schedule_span_configs
  def create
    @schedule_span_config = safe_scope.new(schedule_span_config_params)

    if @schedule_span_config.save
      redirect_to @schedule_span_config, notice: t('schedule_span_config.notify.success.create')
    else
      render :new
    end
  end

  # PATCH/PUT /schedule_span_configs/1
  def update
    if @schedule_span_config.update(schedule_span_config_params)
      redirect_to @schedule_span_config, notice: t('schedule_span_config.notify.success.update')
    else
      render :edit
    end
  end

  # DELETE /schedule_span_configs/1
  def destroy
    @schedule_span_config.destroy
    redirect_to schedule_span_configs_url, notice: t('schedule_span_config.notify.success.destroy')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_schedule_span_config
      @schedule_span_config = safe_scope.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def schedule_span_config_params
      params.require(:schedule_span_config).permit(:owner_id, :owner_type, :name, :relative, :start_span_id, :finish_span_id, :start_time, :finish_time, :time_table, :reschedule_when_time_table_ends)
    end

    def safe_scope
      policy_scope(ScheduleSpanConfig)
    end
end

