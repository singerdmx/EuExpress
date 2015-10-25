module Connection

  attr_reader :client

  def client
    @client ||= Aws::DynamoDB::Client.new
  end

  def get(clazz,
          key)
    request_params = {
        table_name: clazz.get_table_name,
        key: key,
        consistent_read: false
    }
    Rails.logger.info "get_item request_params:\n#{request_params}"
    response = client.get_item(request_params).item
    Rails.logger.info "get_item response:\n#{response.inspect}"
    response
  end

  def batch_get(request_items)
    Rails.logger.info "batch_get_item request_items:\n#{request_items}"
    response = client.batch_get_item({request_items: request_items}).responses
    Rails.logger.info "batch_get_item response:\n#{response.inspect}"
    response
  end

  def query(clazz,
            key_condition_expression,
            expression_attribute_values,
            index_name = nil)
    query_params = {
        table_name: clazz.get_table_name,
        consistent_read: false,
        key_condition_expression: key_condition_expression,
        expression_attribute_values: expression_attribute_values
    }
    query_params[:index_name] = index_name if index_name
    Rails.logger.info "query query_params:\n#{query_params}"
    response = client.query(query_params).items
    Rails.logger.info "query response:\n#{response.inspect}"
    response
  end

  def update(clazz, key, update_expression, expression_attribute_values)
    request_params = {
        table_name: clazz.get_table_name,
        key: key,
        return_values: 'ALL_NEW',
        update_expression: update_expression,
        expression_attribute_values: expression_attribute_values
    }
    Rails.logger.info "update_item request_params:\n#{request_params}"
    response = client.update_item(request_params).attributes
    Rails.logger.info "update_item response:\n#{response.inspect}"
    response
  end

  def delete(clazz, key)
    request_params = {
        table_name:  clazz.get_table_name,
        key: key,
    }
    Rails.logger.info "delete_item request_params:\n#{request_params}"
    response = client.delete_item(request_params)
    Rails.logger.info "delete_item response:\n#{response.inspect}"
    response
  end

end