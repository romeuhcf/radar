# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create(email: ENV['EMAIL'], password: ENV['EMAIL'], password_confirmation: ENV['EMAIL']).confirm!
Destination.create!(kind: 'sms', address: '5511960758475', contacted_times: 4, last_used_at: Date.today)
Carrier.create!(media: 'sms', name: 'XPTO', active:true, implementation_class: 'XptoClass')
