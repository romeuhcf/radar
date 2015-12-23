FactoryGirl.define do
  factory :ftp_config do
    owner {create(:user)}
    host "Host"
    port "21"
    user "User"
    secret "Secret"
    passive false
    kind "FTP"
  end

end
