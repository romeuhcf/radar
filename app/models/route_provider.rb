class RouteProvider < ActiveRecord::Base
  include RouteProviderAdmin
  validates :name, uniqueness: true
  serialize :options, JSON
  scope :enabled, -> {where(enabled: true)}
  validates :priority, numericality: true
  validates :provider_klass, presence:true
  validate :validate_provider_klass_constant


  def service_type_enum
    %w{ SMS_NA SMS_LA }
  end

  def validate_provider_klass_constant
    provider_klass.constantize
  rescue NameError
    errors.add(:provider_klass, "classe desconhecida: #{provider_klass}")
  end
end

#------------------------------------------------------------------------------
# RouteProvider
#
# Name           SQL Type             Null    Default Primary
# -------------- -------------------- ------- ------- -------
# id             int(11)              false           true   
# name           varchar(255)         true            false  
# provider_klass varchar(255)         true            false  
# options        varchar(255)         true            false  
# enabled        tinyint(1)           true            false  
# service_type   varchar(255)         true            false  
# created_at     datetime             false           false  
# updated_at     datetime             false           false  
# priority       int(11)              true            false  
#
#------------------------------------------------------------------------------
