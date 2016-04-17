class TestMessage < Test::Unit::TestCase
  def setup
    @message = Yuimaru::Message.new('from', 'name', 'to')
  end

  def test_from
    assert_equal @message.from, 'from'
  end

  def test_name
    assert_equal @message.name, 'name'
  end

  def test_to
    assert_equal @message.to, 'to'
  end

  test '<<' do
    @message << 'hi'
    assert_equal @message.from, 'hi'
  end

  test '>>' do
    @message >> 'hi'
    assert_equal @message.to, 'hi'
  end
end
