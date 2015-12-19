if defined? Bullet
  Rails.application.config.after_initialize do
    Bullet.enable = true
    Bullet.alert = Rails.env.development?
    Bullet.console = true
    Bullet.rails_logger = true
    Bullet.slack = {
      :webhook_url => "https://hooks.slack.com/services/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",
      :channel => "#bullet",
      :additional_parameters => {
        :icon_url => "http://img4.wikia.nocookie.net/__cb20111221203011/fantendo/images/9/97/Bullet_Cup_Icon_-_Mario_Kart_8_Wii_U.png",
        :mrkdwn => true
      }
    }
  end
end
