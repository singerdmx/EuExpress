module DynamoDatabase

  class Cleaner
    include Connection

    def clean
      table_names = client.list_tables.table_names
      Initializer.load_table_classes.each do |clazz|
        begin
          if table_names.include? clazz.get_table_name
            client.delete_table(table_name: clazz.get_table_name)
          end
        rescue Aws::DynamoDB::Errors::LimitExceededException
          sleep 1
          retry
        end
      end
    end

  end
end
