require "yuimaru/version"
require "yuimaru/message"
require "yuimaru/dsl/default"
require "yuimaru/sequence"

module Yuimaru
  class << self
    attr_accessor :default_env

    def sequence(seq, env: default_env)
      add = -> (v) { current << v if v.is_a?(Yuimaru::Message) }
      trace_var(:$_, add)

      eval(seq, env)

      Sequence.new(current)
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

  Yuimaru.default_env = module DefaultEnv
    using Yuimaru::Dsl::Default
    binding
  end
end
