require 'active_support/concern'

module Translation
  extend ActiveSupport::Concern

  TABLE_NAME_PREFIX = 'huami_forum_'

  included do
    :new_from_hash
    :get_table_name
  end

  module ClassMethods
    def new_from_hash(hash)
      obj = self.new
      hash.each do |k, v|
        obj.attributes[k] = v
      end

      obj
    end

    def get_table_name
      TABLE_NAME_PREFIX + table_name
    end
  end

end