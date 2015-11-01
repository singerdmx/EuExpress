class ChangeIdInUser < ActiveRecord::Migration
  def change
    change_column :users, :id, :bigint
    change_column :mailboxer_receipts, :id, :bigint
    change_column :mailboxer_notifications, :id, :bigint
    change_column :mailboxer_conversations, :id, :bigint
    change_column :mailboxer_conversation_opt_outs, :id, :bigint
  end
end
