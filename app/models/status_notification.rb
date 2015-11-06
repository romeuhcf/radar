class StatusNotification < ActiveRecord::Base
  belongs_to :route_provider
  belongs_to :message
end
