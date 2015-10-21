require 'friendly_id'

class User < ActiveRecord::Base
  extend Autocomplete
  include DefaultPermissions

  extend FriendlyId
  friendly_id :email, :use => [:slugged, :finders]

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

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

end
