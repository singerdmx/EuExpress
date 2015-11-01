# This migration comes from messaging_engine (originally 20130801214110)
class InitialMigration < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :body
      t.datetime :created_at
    end

    create_table :receipts do |t|
      t.belongs_to :recipient
      t.belongs_to :sender
      t.belongs_to :message
      t.boolean :read, :default => false
      t.boolean :trash, :default => false
      t.datetime :created_at
    end

    add_index :receipts, [:recipient_id, :trash, :message_id],             :name => 'by_trashed'
    add_index :receipts, [:recipient_id, :read, :message_id],              :name => 'by_read'
    add_index :receipts, [:sender_id, :message_id],                        :name => 'by_sender'
    add_index :receipts, [:sender_id, :recipient_id, :trash, :message_id], :name => 'by_readable'
  end
end
