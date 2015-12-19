class ApiClientsController < ApplicationController
  after_action :verify_authorized, except: [:new, :index]
  after_action :verify_policy_scoped

  before_action :set_api_client, only: [:show, :edit, :update, :destroy]

  # GET /api_clients
  # GET /api_clients.json
  def index
    @api_clients = safe_scope.all
  end

  # GET /api_clients/1
  # GET /api_clients/1.json
  def show
    authorize @api_client
  end

  # GET /api_clients/new
  def new
    @api_client = safe_scope.new
  end

  # GET /api_clients/1/edit
  def edit
    authorize @api_client
  end

  # POST /api_clients
  # POST /api_clients.json
  def create
    @api_client = safe_scope.new(api_client_params)
    authorize @api_client

    respond_to do |format|
      if @api_client.save
        format.html { redirect_to @api_client, notice: 'Api client was successfully created.' }
        format.json { render :show, status: :created, location: @api_client }
      else
        format.html { render :new }
        format.json { render json: @api_client.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /api_clients/1
  # PATCH/PUT /api_clients/1.json
  def update
    authorize @api_client
    respond_to do |format|
      if @api_client.update(api_client_params)
        format.html { redirect_to @api_client, notice: 'Api client was successfully updated.' }
        format.json { render :show, status: :ok, location: @api_client }
      else
        format.html { render :edit }
        format.json { render json: @api_client.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /api_clients/1
  # DELETE /api_clients/1.json
  def destroy
    @api_client.destroy
    respond_to do |format|
      format.html { redirect_to api_clients_url, notice: 'Api client was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_api_client
      @api_client = safe_scope.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def api_client_params
      params.require(:api_client).permit( :enabled, :description).merge(owner: current_user)
    end

    def safe_scope
      policy_scope(ApiClient)
    end
end
