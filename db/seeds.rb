# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
email = %x{ git config --get user.email }.chomp
puts "Creating user for #{email}"

u1 = User.create(email: email, password: email, password_confirmation: email, confirmed_at: Time.current)
u1.add_role :admin
50.times do
  TransmissionRequest.create!(owner: u1, user: u1, identification: [%w[CSV TXT WEB API].shuffle.first, 'request', SecureRandom.hex(5) ].join(' '), messages_count: rand(3874874), requested_via: %w(web api ftp).shuffle.first, status: %w[processing finished finished cancelled].shuffle.first, created_at: Time.current - (rand( 1000).minutes))
end


d1 = Destination.create!(kind: 'sms', address: '5511960758475', contacted_times: 4, last_used_at: Date.today)
_m1 =  Message.create!(sent_at: Time.current, destination: d1, owner: u1, message_content: MessageContent.create(content: "JOAO, seu saldo devedor eh de R$ 123,33 centavos. Quite hoje e receba um desconto de 20%, Banco Nacional agradece!"))
_m2 =  Message.create!(sent_at: Time.current, destination: d1, owner: u1, message_content: MessageContent.create(content: "Eu gostaria de quitar amanhã, pode ser?"), outgoing: false)
_c1 = ChatRoom.create!(owner: u1, destination: d1, last_contacted_by: u1, answered: false, archived: false)



d2 = Destination.create!(kind: 'sms', address: '5511983483775', contacted_times: 4, last_used_at: Date.today)
_m21=  Message.create!(sent_at: Time.current, destination: d2, owner: u1, message_content: MessageContent.create(content: "MARIA, seu saldo devedor eh de R$ 123,33 centavos. Quite hoje e receba um desconto de 20%, Banco Nacional agradece!"))
_m22=  Message.create!(sent_at: Time.current, destination: d2, owner: u1, message_content: MessageContent.create(content: "Eu nao sou MARIAAAA"), outgoing: false)
_m23=  Message.create!(sent_at: Time.current, destination: d2, owner: u1, message_content: MessageContent.create(content: "Caro(a), estou verificando os nossos cadastros. Desculpe-nos o incomodo"))
_m24=  Message.create!(sent_at: Time.current, destination: d2, owner: u1, message_content: MessageContent.create(content: "OBRIGADO"), outgoing: false)
_c2 = ChatRoom.create!(owner: u1, destination: d2, last_contacted_by: u1, answered: false, archived: false)


