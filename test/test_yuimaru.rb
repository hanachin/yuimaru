class TestYuimaru < Test::Unit::TestCase
  def test_sequence
    seq = Yuimaru.sequence(<<~SEQ)
      # assign $_ should be ignored
      $_ = :hi
      "alice" >> "hi bob" >> "bob"
      "alice" << "hi alice" << "bob"
      "alice" >> "hi carol" >> "carol"
      "alice" << "hi alice" << "carol"
    SEQ
    assert_equal seq[0].from, "alice"
    assert_equal seq[0].name, "hi bob"
    assert_equal seq[0].to, "bob"
    assert_equal seq[1].from, "bob"
    assert_equal seq[1].name, "hi alice"
    assert_equal seq[1].to, "alice"
    assert_equal seq[2].from, "alice"
    assert_equal seq[2].name, "hi carol"
    assert_equal seq[2].to, "carol"
    assert_equal seq[3].from, "carol"
    assert_equal seq[3].name, "hi alice"
    assert_equal seq[3].to, "alice"
  end
end
