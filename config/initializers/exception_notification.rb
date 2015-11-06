if Rails.env.production? or Rails.env.staging?
  Rails.application.config.middleware.use ExceptionNotification::Rack,
    :slack => {
    :webhook_url => "https://hooks.slack.com/services/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",
    :channel => "#exceptions",
    :additional_parameters => {
      :icon_url => "https://cdn1.iconfinder.com/data/icons/nuvola2/48x48/actions/messagebox_warning.png",
      :mrkdwn => true
    }
  }
end
