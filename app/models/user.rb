#------------------------------------------------------------------------------
# User
#
# Name                   SQL Type             Null    Default Primary
# ---------------------- -------------------- ------- ------- -------
# id                     int(11)              false           true   
# email                  varchar(255)         false           false  
# encrypted_password     varchar(255)         false           false  
# reset_password_token   varchar(255)         true            false  
# reset_password_sent_at datetime             true            false  
# remember_created_at    datetime             true            false  
# sign_in_count          int(11)              false   0       false  
# current_sign_in_at     datetime             true            false  
# last_sign_in_at        datetime             true            false  
# current_sign_in_ip     varchar(255)         true            false  
# last_sign_in_ip        varchar(255)         true            false  
# confirmation_token     varchar(255)         true            false  
# confirmed_at           datetime             true            false  
# confirmation_sent_at   datetime             true            false  
# unconfirmed_email      varchar(255)         true            false  
# failed_attempts        int(11)              false   0       false  
# unlock_token           varchar(255)         true            false  
# locked_at              datetime             true            false  
# created_at             datetime             false           false  
# updated_at             datetime             false           false  
#
#------------------------------------------------------------------------------
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
    :registerable,
    :recoverable,
    :rememberable,
    :trackable,
    :validatable,
    :confirmable,
    :lockable,
    :async

  protected
  def confirmation_required?
    false
  end
end
