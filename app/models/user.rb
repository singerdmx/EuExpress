require 'friendly_id'

class User < ActiveRecord::Base
  include DefaultPermissions

  extend FriendlyId
  friendly_id :email, :use => [:slugged, :finders]

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

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

end
