module CustomerMonitoringService
  module_function

  def notify(event, author_id, extra={})
    author = author_id && User.find(author_id)
    author = author ? author.email : 'AnonymouS'
    channel = Rails.env.production? ? "#customer-event" : '#development'
    message = [author, 'had just', event, 'with extra data: ',  extra].compact.join(' ')
    slack_client(event, author).ping(message, channel: channel)
  end

  def slack_client(event, author)
    Slack::Notifier.new(
      "https://hooks.slack.com/services/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",
    )
  end


end
