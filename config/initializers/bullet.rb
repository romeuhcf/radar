Rails.application.config.after_initialize do
  Bullet.enable = true
  Bullet.alert = true
  Bullet.console = true
  Bullet.rails_logger = true
  Bullet.slack = {
    :webhook_url => "https://hooks.slack.com/services/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",
    :channel => "#exceptions",
    :additional_parameters => {
      :icon_url => "http://img4.wikia.nocookie.net/__cb20111221203011/fantendo/images/9/97/Bullet_Cup_Icon_-_Mario_Kart_8_Wii_U.png",
      :mrkdwn => true
    }
  }
end
