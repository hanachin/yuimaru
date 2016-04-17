require "yuimaru/version"
require "yuimaru/message"
require "yuimaru/sequence"

module Yuimaru
  class << self
    using Yuimaru::Sequence

    def sequence(seq)
      eval(seq)
    end
  end
end
