module RailsAdmin
  module Config
    module Actions
      class Masquerade < RailsAdmin::Config::Actions::Base
        # This ensures the action only shows up for Users
        register_instance_option :visible? do
          authorized? && bindings[:object].class == User
        end
        # We want the action on members, not the Users collection
        register_instance_option :member do
          true
        end

        register_instance_option :link_icon do
          'icon-user'
        end
        # You may or may not want pjax for your action
        register_instance_option :pjax? do
          false
        end
      end
    end
  end
end
