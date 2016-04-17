class TestObjectMessaging < Test::Unit::TestCase
  using Yuimaru::ObjectMessaging

  test 'String#<<' do
    message = 'hi' << 'name'

    assert_instance_of Yuimaru::Message, message
    assert_instance_of Yuimaru::Message, $_
    assert_equal message.to, 'hi'
    assert_equal message.name, 'name'
  end

  test 'String#>>' do
    message = 'hi' >> 'name'

    assert_instance_of Yuimaru::Message, message
    assert_instance_of Yuimaru::Message, $_
    assert_equal message.from, 'hi'
    assert_equal message.name, 'name'
  end
end
