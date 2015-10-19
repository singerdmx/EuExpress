module Connection

  attr_reader :client

  def client
    @client ||= Aws::DynamoDB::Client.new
  end

  def table_name
    self.class.table_name
  end

  def query(table_name,
            key_condition_expression,
            expression_attribute_values)
    client.query(
        {
            table_name: table_name,
            consistent_read: false,
            key_condition_expression: key_condition_expression,
            expression_attribute_values: expression_attribute_values
        })
        .items
  end

end