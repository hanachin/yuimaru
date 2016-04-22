require 'tmpdir'

class TestYuimaru < Test::Unit::TestCase
  def test_sequence
    seq = Yuimaru.sequence(<<-SEQ)
      # assign $_ should be ignored
      $_ = :hi
      "alice" >> "hi bob" >> "bob"
      "alice" << "hi alice" << "bob"
      "alice" >> "hi carol" >> "carol"
      "alice" << "hi alice" << "carol"
    SEQ

    Dir.mktmpdir do |dir|
      path = File.join(dir, 'hi.png')
      assert_path_not_exist(path)
      seq.save(path)
      assert_path_exist(path)
    end

    assert_instance_of Yuimaru::Sequence, seq
    assert_equal seq.messages[0].from, "alice"
    assert_equal seq.messages[0].name, "hi bob"
    assert_equal seq.messages[0].to, "bob"
    assert_equal seq.messages[1].from, "bob"
    assert_equal seq.messages[1].name, "hi alice"
    assert_equal seq.messages[1].to, "alice"
    assert_equal seq.messages[2].from, "alice"
    assert_equal seq.messages[2].name, "hi carol"
    assert_equal seq.messages[2].to, "carol"
    assert_equal seq.messages[3].from, "carol"
    assert_equal seq.messages[3].name, "hi alice"
    assert_equal seq.messages[3].to, "alice"
  end
end
