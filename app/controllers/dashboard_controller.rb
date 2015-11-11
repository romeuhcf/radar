class DashboardController < ApplicationController
  before_action :authenticate_user!
  def index
  end

  def charts
    _chart = params['chart']
    render json: (1..10).map{|i| [i.days.ago, rand(100) ]}
  end
end
