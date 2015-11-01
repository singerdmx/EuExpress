require 'friendly_id'
require 'mailboxer/models/messageable'

class User < ActiveRecord::Base
  extend Mailboxer::Models::Messageable::ActiveRecordExtension
  include DefaultPermissions

  mattr_accessor :autocomplete_field

  extend FriendlyId
  friendly_id :email, use: [:slugged, :finders]

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :timeoutable

  acts_as_messageable

  class << self
    def moderate_first_post
      # Default it to true
      @@moderate_first_post != false
    end

    def autocomplete_field
      @@autocomplete_field || "email"
    end

    def per_page
      @@per_page || 20
    end

    def forem_autocomplete(term)
      where("#{User.autocomplete_field} LIKE ?", "%#{term}%").
          limit(10).
          select("#{User.autocomplete_field}, id").
          order("#{User.autocomplete_field}")
    end
  end

  def forem_moderate_posts?
    self.moderate_first_post && !forem_approved_to_post?
  end
  alias_method :forem_needs_moderation?, :forem_moderate_posts?

  def forem_name
    name
  end

  def to_s
    name
  end

  def forem_approved_to_post?
    forem_state == 'approved'
  end

  def forem_spammer?
    forem_state == 'spam'
  end

  #Returning the email address of the model if an email should be sent for this object (Message or Notification).
  #If no mail has to be sent, return nil.
  def mailboxer_email(object)
    #Check if an email should be sent for that object
    #if true
    email
    #if false
    #return nil
  end

end
