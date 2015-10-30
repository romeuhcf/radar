ActionMailer::Base.smtp_settings = {
  :address   => "smtp.mandrillapp.com",
  :port      => 587,
  :user_name => 'romeu.hcf@gmail.com',
  :password  => 'Gq65Qacp1CGqnw6lTDCmog',
  :domain    => 'mailergrid.cmamail.com.br'
}
ActionMailer::Base.delivery_method = :smtp

