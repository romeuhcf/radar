require 'sidekiq/web'
require 'pp'
module Sidekiq
  module Pauser
    module Web
      VIEWS = File.expand_path('views', File.dirname(__FILE__))

      def self.registered(app)
        app.get "/pauser" do
          @queues = Sidekiq::Queue.all
          erb File.read(File.join(VIEWS, 'queues.erb')), locals: {view_path: VIEWS}
        end

        app.get "/pauser/:name/pause" do
          halt 404 unless (name = params[:name])
        pp  queue = Sidekiq::Queue[name]
          halt 404 unless queue
          p queue.pause
          redirect "#{root_path}pauser"
        end

        app.get "/pauser/:name/resume" do
          halt 404 unless (name = params[:name])
        pp  queue = Sidekiq::Queue[name]
          halt 404 unless queue
          p queue.unpause
          redirect "#{root_path}pauser"
        end
      end
    end
  end
end

Sidekiq::Web.register(Sidekiq::Pauser::Web)
Sidekiq::Web.tabs["Pause/Play"] = "pauser"
