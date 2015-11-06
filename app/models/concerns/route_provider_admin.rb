module RouteProviderAdmin
  extend ActiveSupport::Concern

  included do
    rails_admin do
      list do
        field :enabled
        field :priority
        field :service_type
        field :name
        field :provider_klass
      end


      edit do
        field :enabled
        field :priority
        field :service_type
        field :name
        field :provider_klass
        field :options
      end

    end
  end
end
