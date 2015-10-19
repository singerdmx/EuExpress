module Connection

  attr_reader :client

  def client
    @client ||= Aws::DynamoDB::Client.new
  end

  def table_name
    self.class.table_name
  end

end