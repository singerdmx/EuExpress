# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

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
      forem_admin: i == 0)
end

Forem::Category.delete_all
Forem::Forum.delete_all
Forem::Post.delete_all
Forem::Topic.delete_all

# Force-decorate the User class in case it hasn't been yet. Fixes #495.
Forem.decorate_user_class!

###############################
#         Category            #
###############################
Forem::Category.create(name: 'Announcements')
Forem::Category.create(name: 'General Support')
Forem::Category.create(name: 'Accessories')
Forem::Category.create(name: 'Development')

user = User.first
forum = Forem::Forum.find_or_create_by_name(category_id: Forem::Category.first.id,
                                            name: "Announcements",
                                            description: "Mi Band updates")

post = Forem::Post.find_or_initialize_by_text("Instruction")
post.user = user

topic = Forem::Topic.find_or_initialize_by_subject("How to upgrade")
topic.forum = forum
topic.user = user
topic.state = 'approved'
topic.posts = [post]

topic.save!
