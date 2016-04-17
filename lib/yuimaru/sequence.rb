module Yuimaru
  module Sequence
    refine(String) do
      def <<(name)
        Message.new(nil, name, self).tap {|m| Yuimaru.current << m }
      end

      def >>(name)
        Message.new(self, name, nil).tap {|m| Yuimaru.current << m }
      end
    end
  end
end
