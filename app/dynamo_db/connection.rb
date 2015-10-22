module Connection

  attr_reader :client

  def client
    @client ||= Aws::DynamoDB::Client.new
  end

  def table_name
    self.class.table_name
  end

  def get(clazz,
          key)
    client.get_item(
        table_name: clazz.table_name,
        key: key,
        consistent_read: false).item
  end

  def batch_get(request_items)
    client.batch_get_item({request_items: request_items})
  end

  def query(clazz,
            key_condition_expression,
            expression_attribute_values,
            index_name = nil)
    query_params = {
        table_name: clazz.table_name,
        consistent_read: false,
        key_condition_expression: key_condition_expression,
        expression_attribute_values: expression_attribute_values
    }
    query_params[:index_name] = index_name if index_name
    client.query(query_params).items
  end

  def update(clazz, key, update_expression, expression_attribute_values)
    client.update_item(
        table_name: clazz.table_name,
        key: key,
        return_values: 'ALL_NEW',
        update_expression: update_expression,
        expression_attribute_values: expression_attribute_values
    ).attributes
  end

  def delete(table_name, key)
    client.delete_item(
        table_name: table_name,
        key: key,
    )
  end

end