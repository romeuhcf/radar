class FileDownloadRulesController < ApplicationController
  before_action :set_file_download_rule, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized, unless: [:index]
  before_action :authenticate_user!

  # GET /file_download_rules
  # GET /file_download_rules.json
  def index
    smart_listing_create :file_download_rules,
      safe_scope,
      partial: "file_download_rules/list",
      default_sort: {created_at: "desc"}
  end

  # GET /file_download_rules/1
  # GET /file_download_rules/1.json
  def show
  end

  # GET /file_download_rules/new
  def new
    @file_download_rule = FileDownloadRule.new
  end

  # GET /file_download_rules/1/edit
  def edit
  end

  # POST /file_download_rules
  # POST /file_download_rules.json
  def create
    @file_download_rule = safe_scope.new(file_download_rule_params)

    respond_to do |format|
      if @file_download_rule.save
        format.html { redirect_to @file_download_rule, notice: 'File download rule was successfully created.' }
        format.json { render :show, status: :created, location: @file_download_rule }
      else
        format.html { render :new }
        format.json { render json: @file_download_rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /file_download_rules/1
  # PATCH/PUT /file_download_rules/1.json
  def update
    respond_to do |format|
      if @file_download_rule.update(file_download_rule_params)
        format.html { redirect_to @file_download_rule, notice: 'File download rule was successfully updated.' }
        format.json { render :show, status: :ok, location: @file_download_rule }
      else
        format.html { render :edit }
        format.json { render json: @file_download_rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /file_download_rules/1
  # DELETE /file_download_rules/1.json
  def destroy
    @file_download_rule.destroy
    respond_to do |format|
      format.html { redirect_to file_download_rules_url, notice: 'File download rule was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_file_download_rule
    @file_download_rule = safe_scope.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def file_download_rule_params
    params.require(:file_download_rule).permit(:worker_class, :description, :enabled, :schedule, transfer_options: [:server, :port, :user, :pwd, :passive, :remote_path, :patterns] )
  end

  def safe_scope
    policy_scope(FileDownloadRule)
  end
end
