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

user = User.first

###############################
#         DynamoDB            #
###############################

require_relative '../app/dynamo_db/cleaner'
require_relative '../app/dynamo_db/initializer'

cleaner = DynamoDatabase::Cleaner.new
cleaner.clean

DynamoDatabase::Initializer.load_table_classes

read_capacity_units = 10
write_capacity_units = 5

client = Aws::DynamoDB::Client.new

###############################
#         Category            #
###############################

client.create_table(
    attribute_definitions: [
        {
            attribute_name: 'id',
            attribute_type: 'S',
        },
    ],
    table_name: Category.get_table_name,
    key_schema: [
        {
            attribute_name: 'id',
            key_type: 'HASH',
        },
    ],
    provisioned_throughput: {
        read_capacity_units: read_capacity_units,
        write_capacity_units: write_capacity_units,
    },
)

categories = []
categories << Category.create(category_name: 'Announcements')
categories << Category.create(category_name: 'General Support')
categories << Category.create(category_name: 'Accessories')
categories << Category.create(category_name: 'Development')

###############################
#           Forum             #
###############################

client.create_table(
    attribute_definitions: [
        {
            attribute_name: 'category',
            attribute_type: 'S',
        },
        {
            attribute_name: 'id',
            attribute_type: 'S',
        },
        {
            attribute_name: 'forum_name',
            attribute_type: 'S',
        },
    ],
    table_name: Forum.get_table_name,
    key_schema: [
        {
            attribute_name: 'category',
            key_type: 'HASH',
        },
        {
            attribute_name: 'id',
            key_type: 'RANGE',
        },
    ],
    provisioned_throughput: {
        read_capacity_units: read_capacity_units,
        write_capacity_units: write_capacity_units,
    },
    local_secondary_indexes: [
        {
            index_name: 'name_index',
            key_schema: [
                {
                    attribute_name: 'category',
                    key_type: 'HASH',
                },
                {
                    attribute_name: 'forum_name',
                    key_type: 'RANGE',
                },
            ],
            projection: {
                projection_type: 'INCLUDE',
                non_key_attributes: ['id'],
            },
        },
    ],
)

forums = []
forums << Forum.create(category: categories.first.id,
                       forum_name: "Announcements Forum",
                       description: "Mi Band updates")

forums << Forum.create(category: categories.first.id,
                       forum_name: "App Forum",
                       description: "App discussion")

forums << Forum.create(category: categories[1].id,
                       forum_name: "Beginner Forum",
                       description: "Beginner tutorial")

###############################
#           Topic             #
###############################

client.create_table(
    attribute_definitions: [
        {
            attribute_name: 'forum',
            attribute_type: 'S',
        },
        {
            attribute_name: 'id',
            attribute_type: 'S',
        },
        {
            attribute_name: 'last_post_at',
            attribute_type: 'N',
        },
        {
            attribute_name: 'user_id',
            attribute_type: 'N',
        },
    ],
    table_name: Topic.get_table_name,
    key_schema: [
        {
            attribute_name: 'forum',
            key_type: 'HASH',
        },
        {
            attribute_name: 'id',
            key_type: 'RANGE',
        },
    ],
    provisioned_throughput: {
        read_capacity_units: read_capacity_units,
        write_capacity_units: write_capacity_units,
    },
    local_secondary_indexes: [
        {
            index_name: 'last_post_at_index',
            key_schema: [
                {
                    attribute_name: 'forum',
                    key_type: 'HASH',
                },
                {
                    attribute_name: 'last_post_at',
                    key_type: 'RANGE',
                },
            ],
            projection: {
                projection_type: 'INCLUDE',
                non_key_attributes: ['subject'],
            },
        },
        {
            index_name: 'user_index',
            key_schema: [
                {
                    attribute_name: 'forum',
                    key_type: 'HASH',
                },
                {
                    attribute_name: 'user_id',
                    key_type: 'RANGE',
                },
            ],
            projection: {
                projection_type: 'INCLUDE',
                non_key_attributes: ['subject'],
            },
        },
    ],
)

topics = []
topics << Topic.create(
    forum: forums.first.id,
    last_post_at: Time.now.to_i - 10,
    subject: 'How to upgrade',
    user_id: user.id,
    state: 'approved')

topics << Topic.create(
    forum: forums.first.id,
    last_post_at: Time.now.to_i,
    subject: 'Amazfit new function',
    user_id: user.id,
    state: 'approved')

###############################
#           Post              #
###############################

client.create_table(
    attribute_definitions: [
        {
            attribute_name: 'id',
            attribute_type: 'S',
        },
        {
            attribute_name: 'topic',
            attribute_type: 'S',
        },
        {
            attribute_name: 'updated_at',
            attribute_type: 'N',
        },
        {
            attribute_name: 'user_id',
            attribute_type: 'N',
        },
    ],
    table_name: Post.get_table_name,
    key_schema: [
        {
            attribute_name: 'topic',
            key_type: 'HASH',
        },
        {
            attribute_name: 'id',
            key_type: 'RANGE',
        },
    ],
    provisioned_throughput: {
        read_capacity_units: read_capacity_units,
        write_capacity_units: write_capacity_units,
    },
    local_secondary_indexes: [
        {
            index_name: 'updated_at',
            key_schema: [
                {
                    attribute_name: 'topic',
                    key_type: 'HASH',
                },
                {
                    attribute_name: 'updated_at',
                    key_type: 'RANGE',
                },
            ],
            projection: {
                projection_type: 'INCLUDE',
                non_key_attributes: ['text'],
            },
        },
        {
            index_name: 'user_index',
            key_schema: [
                {
                    attribute_name: 'topic',
                    key_type: 'HASH',
                },
                {
                    attribute_name: 'user_id',
                    key_type: 'RANGE',
                },
            ],
            projection: {
                projection_type: 'INCLUDE',
                non_key_attributes: ['text'],
            },
        },
    ],
)

posts = []
posts << Post.create(
    topic: topics.first.id,
    text: 'My own experience',
    state: 'approved',
    user_id: user.id)

sleep 1
posts << Post.create(
    topic: topics.first.id,
    text: 'It does not work',
    state: 'approved',
    user_id: user.id)

###############################
#           Views             #
###############################

client.create_table(
    attribute_definitions: [
        {
            attribute_name: 'id',
            attribute_type: 'S',
        },
        {
            attribute_name: 'user_id',
            attribute_type: 'N',
        },
    ],
    table_name: View.get_table_name,
    key_schema: [
        {
            attribute_name: 'user_id',
            key_type: 'HASH',
        },
        {
            attribute_name: 'id',
            key_type: 'RANGE',
        },
    ],
    provisioned_throughput: {
        read_capacity_units: read_capacity_units,
        write_capacity_units: write_capacity_units,
    },
)

views = []
views << View.create(
    user_id: user.id,
    id: "#{Topic.get_table_name}##{topics.first.id}",
    viewable_id: topics.first.id,
    viewable_type: Topic.get_table_name)

###############################
#           Group             #
###############################

client.create_table(
    attribute_definitions: [
        {
            attribute_name: 'id',
            attribute_type: 'S',
        },
    ],
    table_name: Group.get_table_name,
    key_schema: [
        {
            attribute_name: 'id',
            key_type: 'HASH',
        },
    ],
    provisioned_throughput: {
        read_capacity_units: read_capacity_units,
        write_capacity_units: write_capacity_units,
    },
)

groups = []
groups << Group.create(name: 'Moderator')
groups << Group.create(name: 'Normal User')
groups << Group.create(name: 'Admin')

###############################
#         Membership          #
###############################

client.create_table(
    attribute_definitions: [
        {
            attribute_name: 'group_id',
            attribute_type: 'S',
        },
        {
            attribute_name: 'user_id',
            attribute_type: 'N',
        },
    ],
    table_name: Membership.get_table_name,
    key_schema: [
        {
            attribute_name: 'group_id',
            key_type: 'HASH',
        },
        {
            attribute_name: 'user_id',
            key_type: 'RANGE',
        },
    ],
    provisioned_throughput: {
        read_capacity_units: read_capacity_units,
        write_capacity_units: write_capacity_units,
    },
)

memberships = []
memberships << Membership.create(group_id: groups.first.id,
                                 user_id: user.id)

memberships << Membership.create(group_id: groups[1].id,
                                 user_id: users[1].id)

memberships << Membership.create(group_id: groups[2].id,
                                 user_id: user.id)
memberships << Membership.create(group_id: groups[2].id,
                                 user_id: users[2].id)

###############################
#       ModeratorGroup        #
###############################

client.create_table(
    attribute_definitions: [
        {
            attribute_name: 'group',
            attribute_type: 'S',
        },
        {
            attribute_name: 'forum',
            attribute_type: 'S',
        },
    ],
    table_name: ModeratorGroup.get_table_name,
    key_schema: [
        {
            attribute_name: 'forum',
            key_type: 'HASH',
        },
        {
            attribute_name: 'group',
            key_type: 'RANGE',
        },
    ],
    provisioned_throughput: {
        read_capacity_units: read_capacity_units,
        write_capacity_units: write_capacity_units,
    },
)

moderator_groups = []
forums.each do |forum|
  moderator_groups << ModeratorGroup.create(group: groups.first.id,
                                            forum: forum.id)
  moderator_groups << ModeratorGroup.create(group: groups.last.id,
                                            forum: forum.id)
end

###############################
#         Subscription        #
###############################

client.create_table(
    attribute_definitions: [
        {
            attribute_name: 'topic',
            attribute_type: 'S',
        },
        {
            attribute_name: 'user_id',
            attribute_type: 'N',
        },
    ],
    table_name: Subscription.get_table_name,
    key_schema: [
        {
            attribute_name: 'topic',
            key_type: 'HASH',
        },
        {
            attribute_name: 'user_id',
            key_type: 'RANGE',
        },
    ],
    provisioned_throughput: {
        read_capacity_units: read_capacity_units,
        write_capacity_units: write_capacity_units,
    },
)

subscriptions = []
users.each do |u|
  subscriptions << Subscription.create(topic: topics.first.id,
                                       user_id: u.id)
end

