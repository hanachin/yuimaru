require "yuimaru/version"
require "yuimaru/message"
require "yuimaru/sequence"

module Yuimaru
  class << self
    using Yuimaru::Sequence

    def sequence(seq)
      eval(seq)

      current
    ensure
      reset
    end

    def method_missing(name, *)
      return super if /\A_+\z/ !~ name

      current << []
    end

    def current
      Thread.current[:yuimaru] ||= []
    end

    private

    def reset
      Thread.current[:yuimaru] = nil
    end
  end
end
