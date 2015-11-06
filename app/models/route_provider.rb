class RouteProvider < ActiveRecord::Base
  validates :name, uniqueness: true
  serialize :options, Hash
  scope :enabled, -> {where(enabled: true)}

  def options_as_json=(data)
    self.options = data.to_json
  end

  def options_as_json
    options.to_json
  end

  def provider
    provider_klass.constantize.new(options)
  end
end
