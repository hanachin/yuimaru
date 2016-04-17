require "yuimaru/version"
require "yuimaru/message"
require "yuimaru/object_messaging"
require "yuimaru/sequence"

module Yuimaru
  class << self
    using Yuimaru::ObjectMessaging

    def sequence(seq)
      add = -> (v) { current << v if v.is_a?(Yuimaru::Message) }
      trace_var(:$_, add)

      eval(seq)

      current
    ensure
      untrace_var(:$_, add)
      reset
    end

    def method_missing(name, *)
      return super if /\A_+\z/ !~ name

      current << []
    end

    private

    def current
      Thread.current[:yuimaru] ||= []
    end

    def reset
      Thread.current[:yuimaru] = nil
    end
  end
end
