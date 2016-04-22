require "yuimaru/message"

module Yuimaru
  module Dsl
    module Default
      class << self
        attr_accessor :env
      end

      refine(String) do
        def <<(name)
          $_ = Message.new(nil, name, self)
        end

        def >>(name)
          $_ = Message.new(self, name, nil)
        end
      end

      using self

      self.env = binding
    end
  end
end
