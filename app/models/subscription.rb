class Subscription < OceanDynamo::Table

  dynamo_schema(:guid, create: true,
                timestamps: [:created_at, :updated_at]) do
    attribute :subscriber_id, :integer
  end

  belongs_to :topic, composite_key: true

  validates :subscriber_id, :presence => true

  def send_notification(post_id)
    # If a user cannot be found, then no-op
    # This will happen if the user record has been deleted.
    if subscriber.present?
      mail = SubscriptionMailer.topic_reply(post_id, subscriber.id)
      if mail.respond_to?(:deliver_later)
        mail.deliver_later
      else
        mail.deliver
      end
    end
  end
end
