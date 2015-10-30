class Configuration < ActiveRecord::Base
  serialize :value

  def self.get(key, default_value = nil, default_description = nil)
    stored = where(key: key).first
    unless stored
      stored = create!(key: key, value: default_value, description: default_description || key)
    end
    stored.value
  end
end
