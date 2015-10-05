require 'friendly_id'

class User < ActiveRecord::Base

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
end
