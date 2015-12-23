class ParseConfigsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_parse_config, only: [:show, :edit, :update, :destroy]

  # GET /parse_configs
  def index
    @parse_configs = safe_scope.all
  end

  # GET /parse_configs/1
  def show
  end

  # GET /parse_configs/new
  def new
    @parse_config = safe_scope.new
  end

  # GET /parse_configs/1/edit
  def edit
  end

  # POST /parse_configs
  def create
    @parse_config = safe_scope.new(parse_config_params)

    if @parse_config.save
      redirect_to @parse_config, notice: t('Parse config was successfully created.')
    else
      render :new
    end
  end

  # PATCH/PUT /parse_configs/1
  def update
    if @parse_config.update(parse_config_params)
      redirect_to @parse_config, notice: t('Parse config was successfully updated.')
    else
      render :edit
    end
  end

  # DELETE /parse_configs/1
  def destroy
    @parse_config.destroy
    redirect_to parse_configs_url, notice: 'Parse config was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_parse_config
      @parse_config = safe_scope.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def parse_config_params
      params.require(:parse_config).permit(:kind, :owner_id, :owner_type, :name, :is_message_defined_at_column, :column_of_message, :column_of_number, :column_of_destination_reference, :field_separator, :headers_at_first_line, :custom_message, :skip_records)
    end

    def safe_scope
      policy_scope(ParseConfig)
    end
end

