class TestSequence < Test::Unit::TestCase
  def setup
    @message = Yuimaru::Message.new('alice', 'hi bob', 'bob')
    @sequence = Yuimaru::Sequence.new([message]
  end

  def test_messages
    assert_equal @sequence.messages, [@message]
  end
end
