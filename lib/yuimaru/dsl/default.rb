require "yuimaru/message"

module Yuimaru
  module Dsl
    module Default
      refine(String) do
        def <<(name)
          $_ = Message.new(nil, name, self)
        end

        def >>(name)
          $_ = Message.new(self, name, nil)
        end
      end
    end
  end
end
