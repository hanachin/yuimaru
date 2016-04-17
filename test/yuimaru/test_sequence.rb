class TestSequence < Test::Unit::TestCase
  using Yuimaru::Sequence

  test 'String#<<' do
    message = 'hi' << 'name'

    assert_instance_of Yuimaru::Message, message
    assert_equal message.to, 'hi'
    assert_equal message.name, 'name'
  end

  test 'String#>>' do
    message = 'hi' >> 'name'

    assert_instance_of Yuimaru::Message, message
    assert_equal message.from, 'hi'
    assert_equal message.name, 'name'
  end
end