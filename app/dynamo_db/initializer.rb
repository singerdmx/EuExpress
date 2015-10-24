module DynamoDatabase

  class Initializer

    def self.load_table_classes
      Dir[File.dirname(__FILE__) + "/../models/dynamo/*.rb"].map do |f|
        load f

        class_name = File.basename(f, '.rb').split('_').each do |c|
          c[0] = c[0].capitalize
        end.join
        clazz = Object.const_get(class_name)
        clazz.class_eval do
          include Connection, Translation
        end
      end
    end

  end
end
