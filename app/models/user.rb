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

  def to_s
    name
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
