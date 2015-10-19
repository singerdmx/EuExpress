module DynamoDatabase

  class Cleaner
    include Connection

    def clean
      client.list_tables.table_names.each do |t|
        begin
          client.delete_table({table_name: t})
        rescue Aws::DynamoDB::Errors::LimitExceededException
          sleep 1
          retry
        end
      end
    end

  end
end
