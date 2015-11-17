if Rails.env.staging? or Rails.env.production?
  ActionMailer::Base.smtp_settings = {
    :address   => "smtp.mandrillapp.com",
    :port      => 587,
    :user_name => 'romeu.hcf@gmail.com',
    :password  => 'Gq65Qacp1CGqnw6lTDCmog',
    :domain    => 'mailergrid.cmamail.com.br'
  }
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.default_url_options[:host] = 'http://www.sendorama.com.br'
else
  ActionMailer::Base.delivery_method = :test
end
