require "minitest/autorun"
require "kafka"

class TestKafka < Minitest::Test
  def setup
    @kafka = Kafka.new("kafka://localhost:9092")
    begin
      @kafka.delete_topic("test-messages")
    rescue Kafka::UnknownTopicOrPartition
    end

    @kafka.create_topic("test-messages")
  end

  def test_message_publishing
    producer = @kafka.producer
    producer.produce("hello1", topic: "test-messages")
    assert_nil producer.deliver_messages
  end

  def test_message_receiving
    producer = @kafka.producer
    producer.produce("message-produced", topic: "test-messages")
    producer.deliver_messages

    messages = @kafka.fetch_messages(topic: "test-messages", partition: 0, offset: 0).to_a
    assert_equal 1, messages.size
    assert_equal "message-produced", messages.first.value
  end
end

