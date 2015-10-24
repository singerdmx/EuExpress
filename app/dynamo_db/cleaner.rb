module DynamoDatabase

  class Cleaner
    include Connection

    def clean
      Initializer.load_table_classes.each do |clazz|
        begin
          client.delete_table(table_name: clazz.get_table_name)
        rescue Aws::DynamoDB::Errors::LimitExceededException
          sleep 1
          retry
        end
      end
    end

  end
end
