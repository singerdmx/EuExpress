require 'securerandom'

###############################
#           User              #
###############################
User.delete_all

user_size = 5
users = user_size.times.map do |i|
  User.create(
      email: "user#{i}@test.com",
      password: 'user1234',
      password_confirmation: 'user1234',
      name: 'u' + i.to_s,
      confirmed_at: Time.now,
      confirmation_sent_at: Time.now - 30,
      forem_admin: i == 0)
end

users << User.create(
    email: 'singerdmx@gmail.com',
    password: '12345678',
    password_confirmation: '12345678',
    name: 'Xin Yao',
    confirmed_at: Time.now,
    confirmation_sent_at: Time.now - 30,
    forem_admin: true)

user = User.first