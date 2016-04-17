module Yuimaru
  module Sequence
    refine(String) do
      def <<(name)
        Message.new(nil, name, self)
      end

      def >>(name)
        Message.new(self, name, nil)
      end
    end
  end
end
