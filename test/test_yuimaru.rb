class TestYuimaru < Test::Unit::TestCase
  def test_sequence
    seq = Yuimaru.sequence(<<~SEQ)
      "A" >> "B" >> "C"
    SEQ
    assert_equal seq.from, "A"
    assert_equal seq.name, "B"
    assert_equal seq.to, "C"
  end
end
