class TestSequence < Test::Unit::TestCase
  def setup
    @messages = [
      Yuimaru::Message.new('alice', 'hi carol', 'carol'),
      Yuimaru::Message.new('bob', 'hi carol', 'carol')
    ]
    @sequence = Yuimaru::Sequence.new(@messages)
  end

  def test_actors
    assert_equal @sequence.actors, ['alice', 'carol', 'bob']
  end

  def test_messages
    assert_equal @sequence.messages, @messages
  end
end
