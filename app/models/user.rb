require 'friendly_id'

class User < ActiveRecord::Base
  include DefaultPermissions

  mattr_accessor :autocomplete_field

  extend FriendlyId
  friendly_id :email, use: [:slugged, :finders]

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

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

end
