require 'active_support/concern'

module Translation
  extend ActiveSupport::Concern

  included do
    :new_from_hash
  end

  module ClassMethods
    def new_from_hash(hash)
      obj = self.new
      hash.each do |k, v|
        obj.attributes[k] = v
      end

      obj
    end
  end

end